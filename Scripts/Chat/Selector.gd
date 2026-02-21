extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_green_pressed() -> void:
	Global.current_AI = "green"
	hide()
	get_parent().get_node("AIChatOutput").show()
	get_parent().get_node("AICharSprite").show()


func _on_blue_pressed() -> void:
	Global.current_AI = "blue"
	hide()
	get_parent().get_node("AIChatOutput").show()
	get_parent().get_node("AICharSprite").show()


func _on_pink_pressed() -> void:
	Global.current_AI = "pink"
	hide()
	get_parent().get_node("AIChatOutput").show()
	get_parent().get_node("AICharSprite").show()


func _on_red_pressed() -> void:
	Global.current_AI = "red"
	hide()
	get_parent().get_node("AIChatOutput").show()
	get_parent().get_node("AICharSprite").show()
