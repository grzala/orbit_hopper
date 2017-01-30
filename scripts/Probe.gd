extends RigidBody2D

onready var grav_body = find_node("Grav_Body")
onready var thrust = find_node("Thrust")

var acceleration = Vector2(0, 0)

var slowdown = false
const max_tank = 60
var tank = max_tank

const time_to_regenerate = 1
var unburn_time = 0
var power = 30

func _ready():
	set_contact_monitor(true)
	
	grav_body.tiny = true
	grav_body.type = "probe"
	grav_body.g_mass = 10
	
	set_process(true)

func get_grav():
	return grav_body
	
func _integrate_forces(state):
	if !grav_body.stat:
		set_linear_velocity(get_linear_velocity() + (acceleration))
		var v = -get_linear_velocity()
		var angle = atan2(v.x, v.y)
		set_rot(angle)
		
	acceleration = Vector2(0, 0)

func _process(delta):
	show_thrust(false)
	if slowdown and tank > 0 and get_linear_velocity().length() > 10:
		var angle = atan2(-get_linear_velocity().y, -get_linear_velocity().x)
		var vec = polar(angle, power)
		vec = vec * delta
		burn(vec)
	else:
		refuel(delta)
			
	#print(tank)
	
	slowdown = false
	
	update()
	
	for body in get_colliding_bodies():
		if !body.has_method("get_grav") or body.get_grav().type != "ship":
			die()
			
func burn(vec):
	set_linear_velocity(get_linear_velocity() + vec)
	tank -= vec.length()
	tank = max(0, tank)
	unburn_time = 0
	show_thrust(true)
	
func refuel(d):
	unburn_time += d
	if unburn_time >= time_to_regenerate and tank < max_tank:
		tank += power*d
	tank = min(tank, max_tank)
	
func show_thrust(boolean):
	for c in thrust.get_children():
		if boolean:
			c.show()
		else:
			c.hide()

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

func die():
	if globals.current_probe == self: globals.current_probe = null
	queue_free()

