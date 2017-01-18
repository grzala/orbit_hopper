extends RigidBody2D

onready var grav_body = find_node("Grav_Body")

var acceleration = Vector2(0, 0)
onready var dot_texture = preload("res://sprites/dot.png")

func _ready():
	grav_body.radius = find_node("CollisionShape2D").get_shape().get_radius();
	#scale_sprite(radius)
	set_radius(15)
	set_process(true)
	
	init_dotted_border()

func init_dotted_border():
	var current_angle = 0
	var angle_delta = PI/25.0
	var radius = grav_body.gravity_range
	
	while (current_angle <= PI*2):
		var pos = polar(current_angle, radius)
		
		var sprite = Sprite.new()
		sprite.set_texture(dot_texture)
		sprite.set_pos(pos)
		sprite.set_scale(Vector2(0.25, 0.25))
		add_child(sprite)
		
		current_angle += angle_delta

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
	var tex = load(path)
	
	find_node("Sprite").set_texture(tex)

	


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
	

func polar(angle, radius):
	return Vector2(radius * cos(angle), radius * sin(angle))
	
