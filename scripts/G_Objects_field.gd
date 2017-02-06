
extends Node2D

var bodies = get_children()
const G = 1
const MAXINT = 2147483647

var last_dist = 0

func _ready():
	set_fixed_process(true)
	
	bodies = get_children()
	
	#bodies[0].get_grav().set_static(true)
	#bodies[1].get_grav().set_static(true)
	#bodies[2].get_grav().set_static(true)
	#bodies[1].accelerate(Vector2(0, 500))
	#bodies[0].accelerate(Vector2(0, 200))
	#bodies[2].get_grav().set_gmass(80)
	
func _fixed_process(delta):
	process_gravity(delta)

func process_gravity(delta):
	bodies = get_children()
	apply_gravities_multiple(bodies, delta)
	
	#calculate which body is orbiting which body
	for i in range(bodies.size()):
		var closest_body = null
		var dist = MAXINT
		for j in range(0, bodies.size()): #find closest body
			if i == j: continue
			var d = bodies[i].get_pos().distance_to(bodies[j].get_pos())
			if d < dist:
				dist = d
				closest_body = bodies[j]
		
		var body1 = bodies[i]
		var body2 = closest_body
		if body2 == null: return
		
		if body1.get_grav().calculating_orbit_for != body2: #different body is the closest body now
			body1.get_grav().orbit_start_angle = null
			body1.get_grav().radians_orbited = 0
		
		if dist > body2.get_grav().gravity_range: #not orbiting if out of range
			body1.get_grav().orbiting = null
			body1.get_grav().orbit_start_angle = null
			body1.get_grav().radians_orbited = 0
			continue 
		
		var angle = atan2(body2.get_pos().y - body1.get_pos().y, body2.get_pos().x - body1.get_pos().x)
		#if angle < 0: angle += 2*PI
		
		body1.get_grav().calculating_orbit_for = body2
		if body1.get_grav().orbit_start_angle == null: body1.get_grav().orbit_start_angle = angle
		
		var dif = (angle - body1.get_grav().orbit_start_angle)
		while dif > PI: dif -= 2*PI
		while dif < -PI: dif += 2*PI
		
		body1.get_grav().radians_orbited += dif
		body1.get_grav().orbit_start_angle = angle
		
		if abs(body1.get_grav().radians_orbited) > PI*2: #orbiting
			if body1.get_grav().radians_orbited < 0: body1.get_grav().radians_orbited = -2*PI
			elif body1.get_grav().radians_orbited > 0: body1.get_grav().radians_orbited = 2*PI
			body1.get_grav().orbiting = body1.get_grav().calculating_orbit_for
		else:
			if body1.get_grav().orbiting != null and body1.get_grav().orbiting == body2:
				body1.get_grav().orbiting = null
			
		
	var s = find_node("Ship")
	#print(s.get_grav().radians_orbited)

func apply_gravities_multiple(bodies, delta):
	if bodies == null: return
	for i in range(bodies.size()):
		for j in range(i, bodies.size()):
			if i == j: continue
			
			var body1 = bodies[i]
			var body2 = bodies[j]
			
			var impulse = get_impulse(body1, body2)
			
			#body1.accelerate(impulse[0] * delta)
			#body2.accelerate(impulse[1] * delta)
			
			body1.set_linear_velocity(body1.get_linear_velocity() + (impulse[0] * delta))
			body2.set_linear_velocity(body2.get_linear_velocity() + (impulse[1] * delta))
			
	

func get_impulse(body1, body2):
	var impulse1 = Vector2(0, 0)
	var impulse2 = Vector2(0, 0)
	
	if (body1.get_grav().is_tiny() and body2.get_grav().is_tiny()) or \
		(body1.get_grav().is_static() and body2.get_grav().is_static()):
		return [impulse1, impulse2]
	
	var pos1 = body1.get_pos()
	var pos2 = body2.get_pos()
	var m1 = body1.get_grav().get_gmass()
	var m2 = body2.get_grav().get_gmass()
	
	var angle = atan2(pos2.y - pos1.y, pos2.x - pos1.x)
	var dist = pos1.distance_to(pos2)
	
	var orbiting_around = null
	if m1 > m2:
		orbiting_around = body1
	else:
		orbiting_around = body2
	
	if orbiting_around != null and dist > orbiting_around.get_grav().gravity_range:
		return [impulse1, impulse2]
	
	var mm1 = m1
	var mm2 = m2
	
	#deprecated, left in case of errors
	#if body1.get_grav().is_tiny(): mm1 = m1 
	#else : mm1 = m2
	#if body2.get_grav().is_tiny(): mm2 = m2 
	#else : mm2 = m1
	
	if body1.get_grav().is_tiny() or m1 == 0:
		mm1 = 1.0
	if body2.get_grav().is_tiny() or m2 == 0:
		mm2 = 1.0
	
	var m = max(m1, m2)
	
	var gravity = (G * m) / (dist*dist)
	
	var vec = polar(angle, gravity)
	var rr = body1.get_grav().get_radius() + body2.get_grav().get_radius()
	
	#if body1.get_grav().type == "ship" or body2.get_grav().type == "ship":
		#print(vec.length(), " " , dist)
	
	if dist > last_dist and last_dist < 160:
		last_dist = dist
		#print(last_dist)
	
	if true: #dist >= rr:
		if !body1.get_grav().is_static() and !body2.get_grav().is_tiny() and dist <= body2.get_grav().get_range(): impulse1 = vec
		if !body2.get_grav().is_static() and !body1.get_grav().is_tiny() and dist <= body1.get_grav().get_range(): impulse2 = -vec
		
	
	return [impulse1, impulse2]
	

func polar(angle, radius):
	return Vector2(radius * cos(angle), radius * sin(angle))

func inv(vec):
	return Vector2(-vec.x, -vec.y)

