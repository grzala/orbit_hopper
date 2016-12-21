extends "res://scripts/grav_body.gd"

func _ready():
	radius = find_node("CollisionShape2D").get_shape().get_radius();
	#scale_sprite(radius)
	set_process(true)

func set_radius(radius):
	var shape = CircleShape2D.new()
	shape.set_radius(radius)
	
	find_node("CollisionShape2D").set_shape(shape)
	
	scale_sprite(radius)

func scale_sprite(radius):
	pass
	var temp_sprite_size = 100.0
	temp_sprite_size /= 2 #we need half
	var scale = temp_sprite_size/radius
	scale = 1.0/scale
	scale = Vector2(scale, scale)
	
	find_node("Sprite").set_scale(scale)
	
func _process(delta):
	gravity_process(delta)
	
func _draw():
	var center = Vector2(0,0)
	var radius = gravity_range
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

