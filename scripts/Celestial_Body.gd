extends RigidBody2D

onready var grav_body = find_node("Grav_Body")

var acceleration = Vector2(0, 0)

func _ready():
	grav_body.radius = find_node("CollisionShape2D").get_shape().get_radius();
	#scale_sprite(radius)
	set_radius(15)
	set_process(true)
	
func get_grav():
	return grav_body

func set_radius(radius):
	var shape = CircleShape2D.new()
	shape.set_radius(radius)
	
	clear_shapes()
	add_shape(shape)
	
	scale_sprite(radius)

func scale_sprite(radius):
	var temp_sprite_size = 100.0
	temp_sprite_size /= 2 #we need half
	var scale = temp_sprite_size/radius
	scale = 1.0/scale
	scale = Vector2(scale, scale)
	
	find_node("Sprite").set_scale(scale)

func set_sprite(name):
	var path = "res://sprites/planets/" + name
	print(path)
	var tex = load(path)
	
	find_node("Sprite").set_texture(tex)

func _draw():
	var center = Vector2(0,0)
	var radius = grav_body.gravity_range
	var angle_from = 0
	var angle_to = 359
	var color = Color(1.0, 0.0, 0.0)
	draw_dotted_circle_arc(center, radius, angle_from, angle_to, color)

func draw_dotted_circle_arc( center, radius, angle_from, angle_to, color ):
	var nb_points = 32
	var points_arc = Vector2Array()
	
	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
		var point = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
		points_arc.push_back( point )
	
	for indexPoint in range(0, nb_points, 2):
		draw_line(points_arc[indexPoint], points_arc[indexPoint+1], color)

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