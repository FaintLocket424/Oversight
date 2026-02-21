extends CharacterBody3D

class_name Robot

@export var bot_name: String = "GLaDOS"

@export var ai_model: LLMManager.Model = LLMManager.Model.GEMINI_3_0_FLASH
@export var walk_speed: float = 3.0

@onready var chat_label: Label3D = $Label3D
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_thinking: bool = false

func _ready():
	chat_label.text = ""

func _physics_process(delta):
	# 1. Always apply gravity so the bot doesn't float
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. If the bot is thinking (talking to the AI), stop it from moving
	if is_thinking:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return

	# 3. Simple movement logic (Example: move towards a target)
	# If a path is set in the NavigationAgent, walk along it
	if not nav_agent.is_navigation_finished():
		var current_pos = global_position
		var next_pos = nav_agent.get_next_path_position()
		var direction = current_pos.direction_to(next_pos)
		
		# Keep movement flat on the ground
		direction.y = 0 
		direction = direction.normalized()
		
		velocity.x = direction.x * walk_speed
		velocity.z = direction.z * walk_speed
	else:
		# Stop moving if we arrived
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.z = move_toward(velocity.z, 0, walk_speed)

	# 4. Apply the velocity to the physics engine
	move_and_slide()
	
func interact_with_player(player_message: String):
	# Stop moving and show a typing indicator
	is_thinking = true
	chat_label.text = "[Thinking...]"
	
	# Give the AI a specific personality based on its bot_name
	var prompt = "You are a physical robot in a video game named %s. The player says: '%s'. Reply in 2 sentences or less." % [bot_name, player_message]
	
	# Call our Autoload Service
	var response = await LLMManager.ask(ai_model, prompt)
	
	# Display the result
	chat_label.text = response
	
	# Wait 5 seconds so the player can read it, then clear it and resume moving
	await get_tree().create_timer(5.0).timeout
	chat_label.text = ""
	is_thinking = false

# Example function to tell the bot where to walk
func walk_to_location(target_position: Vector3):
	nav_agent.target_position = target_position
