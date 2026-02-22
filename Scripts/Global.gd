extends Node

@onready var current_AI = "blue"
@onready var stat1 = 1
@onready var talking = false
@onready var input_text = ""
@onready var output_text = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if talking == true:
		print(input_text)
		talking = false
