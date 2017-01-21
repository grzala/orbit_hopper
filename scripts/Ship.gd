extends RigidBody2D

onready var grav_body = find_node("Grav_Body")

var poss = Array()
var time = 1.0

var acceleration = Vector2(0, 0)
func _ready():
	grav_body.type = "ship"
	#grav_body.tiny = true
	#grav_body.g_mass = 200
	grav_body.set_tiny(true)
	
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
	time += delta
	if time > 0.5:
		time = 0
		poss.append(get_pos())

	update()

func _draw():
	draw_set_transform(-get_pos(), 0, Vector2(1, 1))
	for i in range(poss.size()-1):
		i = i
		#draw_line(poss[i], poss[i+1], Color(0, 255, 255), 2)
		#print(i)

func set_rotation(i):
	set_rot(i)
	

func accelerate(vec):
	acceleration += vec
	
func clone():
	var scene = load("res://scenes/Celestial_Body.scn")
	var node = scene.instance()
	node.grav_body = grav_body
	#node.grav_body.stat = grav_body.stat
	#node.grav_body.type = grav_body.type
	#node.grav_body.tiny = grav_body.tiny
	node.set_linear_velocity(get_linear_velocity())
	node.accelerate(acceleration)
	node.set_pos(get_pos())
	
	return node
	
func die():
	queue_free()