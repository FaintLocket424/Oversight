extends Node3D

var rooms: Array[Room] = []

func room_names() -> Array[String]:
	var names: Array[String] = []
	for room in rooms:
		names.append(room.name)
	return names

func _ready() -> void:
	for child in get_children():
		if child is Room:
			rooms.append(child)

func _process(delta: float) -> void:
	pass
