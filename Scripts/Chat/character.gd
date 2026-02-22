extends Node2D

@onready var blue_char = preload("res://assets/Robots/blue.png")
@onready var green_char = preload("res://assets/Robots/green.png")
@onready var pink_char = preload("res://assets/Robots/pink.png")
@onready var red_char = preload("res://assets/Robots/red.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.current_AI == "blue":
		$Character.texture = blue_char
	elif Global.current_AI == "green":
		$Character.texture = green_char
	elif Global.current_AI == "pink":
		$Character.texture = pink_char
	elif Global.current_AI == "red":
		$Character.texture = red_char
