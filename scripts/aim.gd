
extends Node2D

var start = null
var end = null

var vec = null

var ship_pos = null
var ship_vel = null

var grav_field
var bodies

var deltas = Array()
var range_delta = 1
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
	#print("true delta: ", delta / OS.get_time_scale())
	deltas = Array()
	if OS.get_time_scale() > 0:
		
		delta = delta / (OS.get_time_scale());
		deltas.push_back(delta)
		if (deltas.size() > 20): deltas.remove(0)
		if (deltas.size() > 0): d = sum(deltas)/deltas.size()

	update()
	
func simulate(bodies):
	var ship_pos_array = Array()
	ship_pos_array.push_back(bodies[0].get_pos())
	
	var dd = d * range_delta
	#print("dd ", d)
	#dd = 0.03 * range_delta ############################ debug
	
	for i in range(350): # for x deltas
		#update bodies
		for j in range(bodies.size()):
			for k in range(j + 1, bodies.size()):
				if j == k: continue
				
				var body1 = bodies[j]
				var body2 = bodies[k]
				#if body1.get_grav().type == "ship" or body2.get_grav().type == "ship":
					#print("simulatyed")
				var impulse = grav_field.get_impulse(body1, body2)
				
				#print(body2.type) 
				#acceleration simulate
				body1.set_linear_velocity(body1.get_linear_velocity() + (impulse[0] * dd))
				body2.set_linear_velocity(body2.get_linear_velocity() + (impulse[1] * dd))

		#velocity update pos
		for j in range(bodies.size()):
			var body = bodies[j]
			#body._integrate_forces(null)
			if !body.get_grav().is_static(): body.set_pos(body.get_pos() + (body.get_linear_velocity() * dd))
			#if !body.get_grav().is_static(): body.update_pos(dd)
		
		ship_pos_array.push_back(bodies[0].get_pos())
	return ship_pos_array

func duplicate_bodies(bodies):
	var array = Array() 
	
	for i in range(bodies.size()):
		array.push_front(bodies[i].clone())
	
	return array

	
func _draw():
	if DEBUG:
		if start != null and end != null:
			draw_line(start, end, Color(255, 0, 0), 1)
		
		if vec != null:
			#initialize new probe
			var probe = preload("res://scenes/Probe.scn").instance()
			probe._ready()
			probe.set_pos(ship_pos)
			probe.set_linear_velocity(ship_vel + vec)
			
			bodies = duplicate_bodies(grav_field.get_children())
			bodies.push_front(probe)
			var array = simulate(bodies)
			
			#draw
			if (array.size() > 1): for i in range(array.size()-1): draw_line(array[i], array[i+1], Color(0, 0, 255), 1)
	
	
			
	



