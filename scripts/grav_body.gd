const MAXINT = 2147483647

var g_mass = 600000.0
var acceleration = Vector2(0, 0)
var stat = false
var tiny = false
var type = "celestial_body"

var orbiting = null
var calculating_orbit_for = null
var orbit_start_angle = null
var radians_orbited = 0

var gravity_range = 250.0

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
	if boolean == true:
		set_gmass(0)

func get_radius():
	return radius

func get_gmass():
	return g_mass

func set_gmass(m):
	g_mass = m

func is_tiny():
	return tiny
	
func get_circular_orbit_velocity(G, body1, body2):
	var vel
	var m1 = body1.get_grav().get_gmass()
	var m2 = body2.get_grav().get_gmass()
	
	if body1.get_grav().is_tiny(): m1 = 0
	if body2.get_grav().is_tiny(): m2 = 0
	
	var masses = m1 + m2
	var dist = body1.get_pos().distance_to(body2.get_pos())
	vel = G * masses
	vel /= dist
	
	vel = sqrt(vel)
	
	return vel 
	

