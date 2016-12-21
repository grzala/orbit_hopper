extends RigidBody2D

const grav_body_script = preload("res://scripts/grav_body.gd")
onready var grav_body = grav_body_script.new()

func _ready():
	grav_body.gravity_range = 0
	grav_body.radius = 5
	grav_body.g_mass = 5
	grav_body.tiny = true
	grav_body.type = "ship"
	set_process(true)
	
func _process(delta):
	grav_body.gravity_process(delta)
	

	



