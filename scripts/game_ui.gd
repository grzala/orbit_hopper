
extends Area2D

var sprite

func _ready():
	set_process(true)
	set_process_input(true)
	sprite = find_node("test")
	sprite.hide()

func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_touch"):
		sprite.show()
		find_node("ship")
	
	if event.is_action_released("ui_touch"):
		sprite.hide()
		