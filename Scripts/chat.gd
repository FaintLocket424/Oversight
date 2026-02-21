extends Node2D

@onready var blue_char = preload("res://assets/Robots/blue.png")
@onready var blue_box = preload("res://assets/Robots/blue_box.png")
@onready var green_char = preload("res://assets/Robots/green.png")
@onready var green_box = preload("res://assets/Robots/green_box.png")
@onready var pink_char = preload("res://assets/Robots/pink.png")
@onready var pink_box = preload("res://assets/Robots/pink_box.png")
@onready var red_char = preload("res://assets/Robots/red.png")
@onready var red_box = preload("res://assets/Robots/red_box.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.current_AI == "blue":
		$Character.texture = blue_char
		$Box.texture = blue_box
	elif Global.current_AI == "green":
		$Character.texture = green_char
		$Box.texture = green_box
	elif Global.current_AI == "pink":
		$Character.texture = pink_char
		$Box.texture = pink_box
	elif Global.current_AI == "red":
		$Character.texture = red_char
		$Box.texture = red_box
