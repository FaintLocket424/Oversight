extends CharacterBody3D

class_name Robot

signal message_received(message: Dictionary)

class Terminal:
	func parse_instruction(instruction: String):
		pass

@export var bot_name: String = "GLaDOS"
@export var ai_model: LLMManager.Model = LLMManager.Model.GEMINI_3_0_FLASH
@export var walk_speed: float = 3.0

@onready var chat_label: Label3D = $Label3D
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var terminal := Terminal.new()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_thinking: bool = false

var chat_history: Array[Dictionary] = []

func _ready():
	chat_label.text = ""
	
	chat_history.append({
		"role": "system",
		"content": "You are a robot named " + bot_name + ". Keep your responses brief."
	})

func _process(_delta):
	
	if str(Global.input_text) != "":
		var message: Dictionary = {
		"sender": null,
		"sender_name": "human",
		"content": Global.input_text
		}
		Global.input_text = ""
		receive_message(message)

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

func go_to_room(room: GameManager.Room):
	pass

func send_message(target: Node, content: String) -> void:
	# Package the data into a dictionary
	var message: Dictionary = {
		"sender": self,
		"sender_name": bot_name,
		"content": content
	}
	
	# Safely check if the target can receive messages
	if target.has_method("receive_message"):
		target.receive_message(message)
	else:
		push_warning("Attempted to send a message, but target cannot receive messages.")

func receive_message(message: Dictionary) -> void:
	print("[%s] Received message from %s: %s" % [bot_name, message["sender_name"], message["content"]])
	
	# Emit signal for other local scripts (like a state machine)
	message_received.emit(message)
	
	# Decide what to do based on the message type
	_process_message(message)

func _process_message(message: Dictionary) -> void:
	var sender = message["sender"]
	var content = message["content"]
	var sender_name = message.get("sender_name", "Unknown")
	
	is_thinking = true
	chat_label.text = "Thinking..."
	
	chat_history.append({
		"role": "message",
		"content": sender_name + " says " + content
	})
	
	var string_history: String = ""
	for msg in chat_history:
		string_history += msg["role"] + ": " + msg["content"] + "\n"
		
	var ai_response = await LLMManager.ask(ai_model, string_history)
	print("AI Response: \"%s\"" % [ai_response])
	
	chat_history.append({
		"role": "assistant",
		"content": ai_response
	})
	
	is_thinking = false
	chat_label.text = ai_response
	Global.output_text = ai_response
