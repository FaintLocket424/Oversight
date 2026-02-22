class_name Room
extends Area3D

var props: Array[Prop] = []

func prop_names() -> Array[String]:
	var names: Array[String] = []
	for prop in props:
		names.append(prop.name)
	return names

func _ready() -> void:
	for child in get_children():
		if child is Prop:
			props.append(child)

func _process(delta: float) -> void:
	pass

func describe() -> String:
	var description: String = "You are in %s. You see " % [name]
	description += ", ".join(prop_names()) + ". "
	
	for prop in props:
		description += prop.describe()
		
	return description
