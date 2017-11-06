extends Node2D

var goal
var hud

func ready(i):
	set_process(true)
	init_level(i)
	hud = find_node("HUD")
	hud.set_level(i)

func init_level(i):
	globals.level_no = i
	globals.current_level = self
	
func make_orbit(body1, body2):
	var G = find_node("G_Objects_Field").G
	var vel = body1.get_grav().get_circular_orbit_velocity(G, body1, body2)
	var angle = atan2(body2.get_pos().y - body1.get_pos().y, body2.get_pos().x - body1.get_pos().x)
	angle = angle - PI/2.0 
	
	body1.set_linear_velocity(polar(angle, vel))

func _process(delta):
	var field = find_node("G_Objects_Field")
	var probe = null
	var ship = field.find_node("Ship")
	
	if ship == null:
		reset()
	
	for p in field.get_children():
		if p.get_name() == "Probe": probe = p
	
	if probe != null:
		#print(probe.get_grav().radians_orbited)
		if probe.get_grav().orbiting != null: 
			ship.set_pos(probe.get_pos())
			ship.set_linear_velocity(probe.get_linear_velocity())
			
			ship.get_grav().orbiting = probe.get_grav().orbiting
			ship.get_grav().calculating_orbit_for = probe.get_grav().calculating_orbit_for
			ship.get_grav().orbit_start_angle = probe.get_grav().orbit_start_angle
			ship.get_grav().radians_orbited = probe.get_grav().radians_orbited
			
			field.remove_child(probe)
			
	if ship != null and ship.get_grav().orbiting == goal:
		complete()
		
	if has_method("custom_process"): custom_process(delta)


func complete():
	if (globals.level_no < globals.max_level):
		get_tree().change_scene("res://scenes/levels/level" + str(globals.level_no+1) + ".tscn")
	else:
		get_tree().change_scene("res://scenes/finish.scn")

func reset():
	get_tree().change_scene("res://scenes/levels/level" + str(globals.level_no) + ".tscn")

func polar(angle, radius):
	return Vector2(radius * cos(angle), radius * sin(angle))