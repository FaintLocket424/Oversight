extends Node3D

@onready var viewport = %"ScreenViewport"

var map_scene = preload("res://Scenes/Map.tscn")
var chat_scene = preload("res://Scenes/Chat.tscn")
var stats_scene = preload("res://Scenes/Stats.tscn")

var current_view_index: int = 0
var cameras: Array[Camera3D] = []

var map_instance: Node3D = null
var chat_instance: Node = null
var stats_instance: Node = null

func _ready():
	setup_map_and_cameras()

func _process(_delta):
	var total_views = cameras.size() + 2
	
	if Input.is_action_just_pressed("Scene_1"):
		set_active_view(0)
	elif Input.is_action_just_pressed("Scene_2"):
		set_active_view(1)
	elif Input.is_action_just_pressed("Scene_3"):
		set_active_view(2)
	elif Input.is_action_just_pressed("Scene_4"):
		set_active_view(3)
	elif Input.is_action_just_pressed("Scene_5"):
		set_active_view(4)
	elif Input.is_action_just_pressed("Scene_Right"):
		var next_view = wrapi(current_view_index + 1, 0, total_views)
		set_active_view(next_view)
	elif Input.is_action_just_pressed("Scene_Left"):
		var prev_view = wrapi(current_view_index - 1, 0, total_views)
		set_active_view(prev_view)
		
	elif Input.is_action_just_pressed("Blue"):
		Global.current_AI = "blue"
	elif Input.is_action_just_pressed("Green"):
		Global.current_AI = "green"
	elif Input.is_action_just_pressed("Pink"):
		Global.current_AI = "pink"
	elif Input.is_action_just_pressed("Red"):
		Global.current_AI = "red"

func setup_map_and_cameras():
	for child in viewport.get_children():
		child.queue_free()
	
	map_instance = map_scene.instantiate()
	viewport.add_child(map_instance)
	
	chat_instance = chat_scene.instantiate()
	viewport.add_child(chat_instance)
	
	stats_instance = stats_scene.instantiate()
	viewport.add_child(stats_instance)
	
	cameras.clear()
	var cam1 = map_instance.find_child("Camera1", true, false)
	var cam2 = map_instance.find_child("Camera2", true, false)
	var cam3 = map_instance.find_child("Camera3", true, false)
	
	if cam1: cameras.append(cam1)
	if cam2: cameras.append(cam2)
	if cam3: cameras.append(cam3)

	set_active_view(0)

func set_active_view(index: int):
	current_view_index = index
	stats_instance.visible = false
	chat_instance.visible = false
	map_instance.visible = false
	
	if index == 0:
		stats_instance.visible = true
		
	elif index == 1:
		chat_instance.visible = true
		
	else:
		map_instance.visible = true
		
		var camera_index = index - 2
		
		if camera_index >= 0 and camera_index < cameras.size():
			cameras[camera_index].current = true
