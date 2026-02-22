extends Node2D

@onready var blue_box = preload("res://assets/Robots/blue_input.png")
@onready var green_box = preload("res://assets/Robots/green_input.png")
@onready var pink_box = preload("res://assets/Robots/pink_input.png")
@onready var red_box = preload("res://assets/Robots/red_input.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.current_AI == "blue":
		$TextBox.texture = blue_box
	elif Global.current_AI == "green":
		$TextBox.texture = green_box
	elif Global.current_AI == "pink":
		$TextBox.texture = pink_box
	elif Global.current_AI == "red":
		$TextBox.texture = red_box


func _on_line_edit_text_submitted(new_text: String) -> void:
	print(new_text)
