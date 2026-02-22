extends Node2D

@onready var blue_box = preload("res://assets/Robots/blue_box.png")
@onready var green_box = preload("res://assets/Robots/green_box.png")
@onready var pink_box = preload("res://assets/Robots/pink_box.png")
@onready var red_box = preload("res://assets/Robots/red_box.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AIOutput.text = Global.output_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.current_AI == "blue":
		$AIBox.texture = blue_box
	elif Global.current_AI == "green":
		$AIBox.texture = green_box
	elif Global.current_AI == "pink":
		$AIBox.texture = pink_box
	elif Global.current_AI == "red":
		$AIBox.texture = red_box
