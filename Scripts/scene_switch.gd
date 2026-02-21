extends Node3D

@onready var viewport = %"ScreenViewport"

var map_scene = preload("res://Scenes/Map.tscn")
var chat_scene = preload("res://Scenes/Chat.tscn")
var stats_scene = preload("res://Scenes/Stats.tscn")
var blank_scene = preload("res://Scenes/Blank.tscn") # New Blank Scene

var current_view_index: int = 0
var cameras: Array[Camera3D] = []

var map_instance: Node3D = null
var blank_instance: Node = null # Reference for the monitor's "Off" state
var active_2d_node: Node = null # The 2D UI overlay on the player's screen

func _ready():
	setup_monitor_content()

func _process(_delta):
	var total_views = cameras.size() + 2
	
	if Input.is_action_just_pressed("Scene_1"):
		set_active_view(0) # Stats
	elif Input.is_action_just_pressed("Scene_2"):
		set_active_view(1) # Chat
	elif Input.is_action_just_pressed("Scene_3"):
		set_active_view(2) # Camera 1
	elif Input.is_action_just_pressed("Scene_Right"):
		var next_view = wrapi(current_view_index + 1, 0, total_views)
		set_active_view(next_view)
	elif Input.is_action_just_pressed("Scene_Left"):
		var prev_view = wrapi(current_view_index - 1, 0, total_views)
		set_active_view(prev_view)
	
	# Global AI logic... (Blue, Green, etc)

func setup_monitor_content():
	# Clean viewport
	for child in viewport.get_children():
		child.queue_free()
	
	# 1. Load the Map into the monitor
	map_instance = map_scene.instantiate()
	viewport.add_child(map_instance)
	
	# 2. Load the Blank scene into the monitor (hidden by default)
	blank_instance = blank_scene.instantiate()
	viewport.add_child(blank_instance)
	blank_instance.visible = false
	
	# 3. Find cameras inside the Map
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
	
	# REMOVE current 2D overlay from the main screen
	if active_2d_node:
		active_2d_node.queue_free()
		active_2d_node = null

	# HANDLE MODES
	if index == 0 or index == 1:
		# --- 2D OVERLAY MODE ---
		# 1. Show Blank.tscn on the monitor
		map_instance.visible = false
		blank_instance.visible = true
		
		# 2. Add the interactive UI to the main screen
		if index == 0:
			active_2d_node = stats_scene.instantiate()
		else:
			active_2d_node = chat_scene.instantiate()
		add_child(active_2d_node)
		
	else:
		# --- 3D CAMERA MODE ---
		# 1. Show the Map on the monitor, hide the Blank screen
		map_instance.visible = true
		blank_instance.visible = false
		
		# 2. Set the correct camera
		var camera_index = index - 2
		if camera_index >= 0 and camera_index < cameras.size():
			cameras[camera_index].current = true
