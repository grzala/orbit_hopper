extends RigidBody2D

onready var grav_body = find_node("Grav_Body")

var acceleration = Vector2(0, 0)

func _ready():
	grav_body.tiny = true
	grav_body.type = "probe"
	set_process(true)

func get_grav():
	return grav_body

func _process(delta):
	if !grav_body.stat:
		set_linear_velocity(get_linear_velocity() + (acceleration * delta))
		#set_pos(get_pos() + velocity * delta)
	acceleration = Vector2(0, 0)
	update()

func accelerate(vec):
	acceleration += vec
	
func clone():
	var scene = load("res://scenes/Celestial_Body.scn")
	var node = scene.instance()
	node.grav_body = grav_body
	node.grav_body.stat = grav_body.stat
	node.grav_body.type = grav_body.type
	node.grav_body.tiny = grav_body.tiny
	node.set_linear_velocity(get_linear_velocity())
	node.accelerate(acceleration)
	node.set_pos(get_pos())
	
	return node
	