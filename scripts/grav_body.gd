const MAXINT = 2147483647

var g_mass = 80
var acceleration = Vector2(0, 0)
var stat = false
var tiny = false
var type = "celestial_body"

var gravity_range = 250

export var radius = 20.0

func get_range():
	return gravity_range

func is_static():
	return stat

func set_static(boolean):
	stat = boolean
	get_parent().set_mass(MAXINT)

func set_tiny(boolean):
	tiny = boolean

func get_radius():
	return radius

func get_gmass():
	return g_mass

func set_gmass(m):
	g_mass = m

func is_tiny():
	return tiny

	
