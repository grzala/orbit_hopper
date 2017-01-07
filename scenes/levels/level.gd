extends Node2D

func _process(delta):
	var field = find_node("G_Objects_Field")
	var probe = null
	for p in field.get_children():
		if p.get_name() == "Probe": probe = p
	
	if probe != null:
		if probe.get_grav().orbiting != null: 
			var ship = field.find_node("Ship")
			ship.set_pos(probe.get_pos())
			ship.set_linear_velocity(probe.get_linear_velocity())
			
			field.remove_child(probe)
