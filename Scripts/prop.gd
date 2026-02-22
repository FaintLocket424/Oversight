class_name Prop
extends StaticBody3D

enum State {
	NORMAL,
	BROKEN
}

var state_description: Dictionary = {
	State.BROKEN: "%s is broken."
}

var state: State = State.NORMAL

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func describe() -> String:
	if state == State.NORMAL:
		return ""
	
	return state_description[state] % [name] + " "
	
	
