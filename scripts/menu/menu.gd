extends CanvasLayer

var button

func _ready():
	button = find_node("Button")
	print("loaded")

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/levels/level1.tscn")
