extends "res://scripts/grav_body.gd"


func _ready():
	tiny = true
	type = "probe"
	set_process(true)
	
func _process(delta):
	gravity_process(delta)


