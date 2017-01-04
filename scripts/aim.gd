
extends Node2D

var start = null
var end = null

var vec = null

var ship_pos = null
var ship_vel = null

var grav_field
var bodies

var deltas = Array()
var range_delta = 10
var d = 0

var last_scale = 0

const DEBUG = true

onready var probe = preload("res://scenes/Probe.scn").instance()

func _ready():
	set_process(true)
	
	grav_field = get_node("/root/orbit_hopper/G_Objects_Field")
	bodies = duplicate_bodies(grav_field.get_children())
	
func sum(array):
	var sum = 0
	for n in array:
		sum += n
	return sum

func _process(delta):
#	ship_pos_array = Array()
#	bodies = duplicate_bodies(grav_field.get_children())
#	ship_pos_array.push_back(bodies[0].get_pos())
#	
#	var d = range_delta
#	
#	#higher range, with some accuracy loss - increase delta
#	#delta *= 4.0
#	for i in range(25):
#		#update bodies
#		for j in range(bodies.size()):
#			for k in range(j + 1, bodies.size()):
#				if j == k: continue
#				
#				var body1 = bodies[j]
#				var body2 = bodies[k]
#				
#				var impulse = grav_field.get_impulse(body1, body2)
#				
#				#print(body2.type) 
#				
#				#acceleration
#				if !body1.get_grav().is_static(): body1.set_linear_velocity(body1.get_linear_velocity() + (impulse[0] * d))
#				if !body2.get_grav().is_static(): body2.set_linear_velocity(body2.get_linear_velocity() + (impulse[1] * d))
#
#		#velocity update pos
#		for j in range(bodies.size()):
#			var body = bodies[j]
#			if !body.get_grav().is_static(): body.set_pos(body.get_pos() + (body.get_linear_velocity() * d))
#				
#				
#		
#		ship_pos_array.push_back(bodies[0].get_pos())
#	
	if last_scale != OS.get_time_scale():
		last_scale = OS.get_time_scale()
		deltas = Array()
	delta = delta / (last_scale);
	deltas.push_back(delta)
	if (deltas.size() > 1): deltas.remove(0)
	if (deltas.size() > 0): d = sum(deltas)/deltas.size()

	update()
	
func simulate(bodies):
	var ship_pos_array = Array()
	ship_pos_array.push_back(bodies[0].get_pos())
	
	var dd = d * range_delta
	
	#higher range, with some accuracy loss - increase delta
	#delta *= 4.0
	for i in range(50):
		#update bodies
		for j in range(bodies.size()):
			for k in range(j + 1, bodies.size()):
				if j == k: continue
				
				var body1 = bodies[j]
				var body2 = bodies[k]
				
				var impulse = grav_field.get_impulse(body1, body2)
				
				#print(body2.type) 
				#acceleration
				if !body1.get_grav().is_static(): body1.set_linear_velocity(body1.get_linear_velocity() + (impulse[0] * dd))
				if !body2.get_grav().is_static(): body2.set_linear_velocity(body2.get_linear_velocity() + (impulse[1] * dd))

		#velocity update pos
		for j in range(bodies.size()):
			var body = bodies[j]
			if !body.get_grav().is_static(): body._process(0)
			if !body.get_grav().is_static(): body.set_pos(body.get_pos() + (body.get_linear_velocity() * dd))
				
		
		ship_pos_array.push_back(bodies[0].get_pos())
	return ship_pos_array

func duplicate_bodies(bodies):
	var array = Array() 
	
	for i in range(bodies.size()):
		array.push_front(bodies[i].clone())
		#else: array.push_back(bodies[i].clone())

	return array

	
func _draw():
	if DEBUG:
		if start != null and end != null:
			draw_line(start, end, Color(255, 0, 0), 1)
		
		if vec != null:
			#initialize new probe
			var probe = preload("res://scenes/Probe.scn").instance()
			probe._ready()
			probe.accelerate(vec)
			probe.set_pos(ship_pos)
			probe.set_linear_velocity(ship_vel + vec * d)
			
			bodies = duplicate_bodies(grav_field.get_children())
			bodies.push_front(probe)
			var array = simulate(bodies)
			
			#draw
			if (array.size() > 1): for i in range(array.size()-1): draw_line(array[i], array[i+1], Color(0, 0, 255), 1)
	
	
			
	


