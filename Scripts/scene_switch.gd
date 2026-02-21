extends Node3D

@onready var viewport = %"ScreenViewport"

var current_room_index: int = 0

var room_1 = preload("res://Scenes/Rooms/Room1.tscn")
var room_2 = preload("res://Scenes/Rooms/Room2.tscn")
var room_3 = preload("res://Scenes/Rooms/Room3.tscn")

@onready var room_list: Array[PackedScene] = [room_1, room_2, room_3]

func _ready():
	load_scene_into_monitor(0)

func _process(_delta):
	if Input.is_action_just_pressed("Scene_1"):
		load_scene_into_monitor(0)
	elif Input.is_action_just_pressed("Scene_2"):
		load_scene_into_monitor(1)
	elif Input.is_action_just_pressed("Scene_3"):
		load_scene_into_monitor(2)
	elif Input.is_action_just_pressed("Scene_Right"):
		var next_room = wrapi(current_room_index + 1, 0, room_list.size())
		load_scene_into_monitor(next_room)
	elif Input.is_action_just_pressed("Scene_Left"):
		var prev_room = wrapi(current_room_index - 1, 0, room_list.size())
		load_scene_into_monitor(prev_room)
	elif Input.is_action_just_pressed("Blue"):
		Global.current_AI = "blue"
	elif Input.is_action_just_pressed("Green"):
		Global.current_AI = "green"
	elif Input.is_action_just_pressed("Pink"):
		Global.current_AI = "pink"
	elif Input.is_action_just_pressed("Red"):
		Global.current_AI = "red"
		

func load_scene_into_monitor(room_index: int):
	current_room_index = room_index
	
	var scene_to_load = room_list[current_room_index]
	
	if scene_to_load == null:
		return
		
	for child in viewport.get_children():
		child.queue_free()
		
	var new_scene = scene_to_load.instantiate()
	
	viewport.add_child(new_scene)
