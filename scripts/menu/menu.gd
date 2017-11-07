extends CanvasLayer

var button

func _ready():
	button = find_node("Button")
	print("loaded")

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/levels/level1.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_SpecialButton_pressed():
	get_tree().change_scene("res://scenes/levels/level5.tscn")
	#get_tree().change_scene("res://scenes/finish.scn")
	


func _on_SpecialButton2_pressed():
	get_tree().change_scene("res://scenes/levels/level4.tscn")
