const MAXINT = 2147483647

var g_mass = 50
var acceleration = Vector2(0, 0)
var stat = false
var tiny = false
var type = "celestial_body"

var gravity_range = 150

var radius = 20.0

var velocity = Vector2(0, 0)

func get_range():
	return gravity_range

func is_static():
	return stat

func set_static(boolean):
	stat = boolean
	set_mass(MAXINT)

func set_tiny(boolean):
	tiny = boolean

func get_radius():
	return radius

func get_gmass():
	return g_mass

func is_tiny():
	return tiny

func gravity_process(delta):
	if !stat:
		set_linear_velocity(get_linear_velocity() + (acceleration * delta))
		#set_pos(get_pos() + velocity * delta)
	acceleration = Vector2(0, 0)
	update()

func accelerate(vec):
	acceleration += vec
