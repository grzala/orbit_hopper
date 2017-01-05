extends CanvasLayer

var button

func _ready():
	button = find_node("Button")


func _on_Button_button_down():
	get_tree().change_scene("res://scenes/levels/level1.tscn")
