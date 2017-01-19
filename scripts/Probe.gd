extends RigidBody2D

onready var grav_body = find_node("Grav_Body")

var acceleration = Vector2(0, 0)
const friction = 0.000

var slowdown = false
var tank = 100

const time_to_regenerate = 1
var unburn_time = 0

func _ready():
	grav_body.tiny = true
	grav_body.type = "probe"
	grav_body.g_mass = 10
	set_process(true)

func get_grav():
	return grav_body

func _process(delta):
	if !grav_body.stat:
		set_linear_velocity(get_linear_velocity() + (acceleration))
		set_rot(get_linear_velocity().angle() + PI)
		
	acceleration = Vector2(0, 0)
	
	
	set_pos(get_pos() + get_linear_velocity()*delta) #instead of update call?
	
	if slowdown and tank > 0:
		var power = 30
		var angle = atan2(-get_linear_velocity().y, -get_linear_velocity().x)
		var vec = polar(angle, power)
		vec = vec * delta
		set_linear_velocity(get_linear_velocity() + vec)
		tank -= vec.length()
		
		unburn_time = 0
	else:
		unburn_time += delta
		if unburn_time >= time_to_regenerate:
			tank += 30*delta
			
	#print(tank)
	
	slowdown = false
	#update()

func accelerate(vec):
	acceleration += vec
	
func slow_down():
	slowdown = true

func polar(angle, radius):
	return Vector2(radius * cos(angle), radius * sin(angle))
	
	
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
	