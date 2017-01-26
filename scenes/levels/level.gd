extends Node2D

var goal

func _process(delta):
	var field = find_node("G_Objects_Field")
	var probe = null
	var ship = field.find_node("Ship")
	
	if ship == null:
		reset()
	
	for p in field.get_children():
		if p.get_name() == "Probe": probe = p
	
	if probe != null:
		print(probe.get_grav().radians_orbited)
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


func complete():
	get_tree().change_scene("res://scenes/levels/level" + str(globals.level_no+1) + ".tscn")

func reset():
	get_tree().change_scene("res://scenes/levels/level" + str(globals.level_no) + ".tscn")

func polar(angle, radius):
	return Vector2(radius * cos(angle), radius * sin(angle))