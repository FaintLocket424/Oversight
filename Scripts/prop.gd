class_name Prop
extends StaticBody3D

enum State {
	NORMAL,
	BROKEN
}

@export var prop_name: String
var state: State = State.NORMAL

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
