extends CanvasLayer

var button

func _ready():
	button = find_node("Button")
	get_tree().change_scene("res://scenes/levels/level1.tscn")
	print("loaded")

func _on_Button_button_down():
	get_tree().change_scene("res://scenes/levels/level1.tscn")
