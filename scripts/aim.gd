
extends Node2D

var start = null
var end = null

var ship_pos_array
var ship

var debug_ar

var grav_field
var bodies

const DEBUG = true

func _ready():
	ship_pos_array = Array()
	debug_ar = Array()
	set_process(true)
	ship = get_node("/root/orbit_hopper/G_Objects_Field/Ship")
	
	grav_field = get_node("/root/orbit_hopper/G_Objects_Field")
	bodies = duplicate_bodies(grav_field.get_children())

func _process(delta):
	ship_pos_array = Array()
	debug_ar = Array()
	bodies = duplicate_bodies(grav_field.get_children())
	ship_pos_array.push_back(bodies[0].get_pos())
	debug_ar.push_back(bodies[1].get_pos())
	
	for i in range(1):
		#update bodies
		for i in range(bodies.size()):
			for j in range(i, bodies.size()):
				if i == j: continue
				
				var body1 = bodies[i]
				var body2 = bodies[j]
				
				var impulse = grav_field.get_impulse(body1, body2)
				
				#print(body2.type)
				
				if !body1.is_static(): body1.set_linear_velocity(body1.get_linear_velocity() + (impulse[0] * delta))
				if !body2.is_static(): body2.set_linear_velocity(body2.get_linear_velocity() + (impulse[1] * delta))
				if !body1.is_static(): body1.set_pos(body1.get_pos() + (body1.get_linear_velocity() * delta))
				if !body2.is_static(): body2.set_pos(body2.get_pos() + (body2.get_linear_velocity() * delta))
				
				
				
		ship_pos_array.push_back(bodies[0].get_pos())
		debug_ar.push_back(bodies[1].get_pos())
	update()

func duplicate_bodies(bodies):
	var array = Array()
	
	for i in range(bodies.size()):
		if bodies[i].type == "ship": array.push_back(bodies[i].duplicate(true))
		else: array.push_back(bodies[i].duplicate(true))
	
	print(bodies[1].type)
	print(bodies[2].type)
	print(array[1].type)
	print(array[2].type)
	
	print("\n")

	return array
	
	
func _draw():
	if DEBUG:
		if start != null and end != null:
	    	draw_line(start, end, Color(255, 0, 0), 1)
	
	if ship_pos_array.size() > 1: 
		for i in range(ship_pos_array.size()-1):
		#print(ship_pos_array[0], " ", ship_pos_array[1])
			draw_line(ship_pos_array[i], ship_pos_array[i+1], Color(0, 0, 255), 1)
			draw_line(debug_ar[i], debug_ar[i+1], Color(0, 0, 255), 1)
			
	draw_line(Vector2(837.238647, 170.987701), Vector2(0, 0), Color(0, 0, 255), 1)
	


