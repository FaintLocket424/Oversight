extends Node2D

# 1. Preload the scenes and textures
@onready var output_box_scene = preload("res://Scenes/Chat/AIChatOutput.tscn")

# Using a Dictionary makes the code much cleaner and easier to manage
@onready var ai_textures = {
	"blue": preload("res://assets/Robots/blue_input.png"),
	"green": preload("res://assets/Robots/green_input.png"),
	"pink": preload("res://assets/Robots/pink_input.png"),
	"red": preload("res://assets/Robots/red_input.png")
}

var last_ai = ""

func _ready() -> void:
	update_ai_appearance()
	$AICharSprite.hide()
	$HumanInput.hide()
	$TextBox.hide()

func _process(_delta: float) -> void:
	if Global.current_AI != last_ai:
		update_ai_appearance()

func update_ai_appearance():
	last_ai = Global.current_AI
	if ai_textures.has(Global.current_AI):
		$TextBox.texture = ai_textures[Global.current_AI]

func _on_human_input_text_submitted(new_text: String) -> void:
	Global.input_text = new_text
	Global.talking = true
	
	var chat_instance = output_box_scene.instantiate()
	chat_instance.position.x = 800
	chat_instance.position.y = 380
	add_child(chat_instance)
