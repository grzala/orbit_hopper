
extends Node2D

var bodies = get_children()
const G = 1

func _ready():
	set_process(true)
	
	bodies = get_children()
	
	bodies[0].get_grav().set_static(true)
	bodies[1].accelerate(Vector2(0, 500))
	bodies[2].get_grav().set_gmass(100)
	
func _process(delta):
	process_gravity()

func process_gravity():
	bodies = get_children()
	apply_gravities_multiple(bodies)

func apply_gravities_multiple(bodies):
	if bodies == null: return
	for i in range(bodies.size()):
		for j in range(i, bodies.size()):
			if i == j: continue
			
			var body1 = bodies[i]
			var body2 = bodies[j]
			
			var impulse = get_impulse(body1, body2)
			
			body1.accelerate(impulse[0])
			body2.accelerate(impulse[1])
	

func get_impulse(body1, body2):
	var impulse1 = Vector2(0, 0)
	var impulse2 = Vector2(0, 0)
	
	var pos1 = body1.get_pos()
	var pos2 = body2.get_pos()
	var m1 = body1.get_grav().get_gmass()
	var m2 = body2.get_grav().get_gmass()
	
	var angle = atan2(pos2.y - pos1.y, pos2.x - pos1.x)
	var dist = pos1.distance_to(pos2)
	var gravity = G * (m1*m2/dist*dist)
	var vec = polar(angle, gravity)
	var rr = body1.get_grav().get_radius() + body2.get_grav().get_radius()
	
	if dist >= rr:
		if !body1.get_grav().is_static() and !body2.get_grav().is_tiny() and dist <= body2.get_grav().get_range(): impulse1 = vec/m1
		if !body2.get_grav().is_static() and !body1.get_grav().is_tiny() and dist <= body1.get_grav().get_range(): impulse2 = -vec/m2
	
	return [impulse1, impulse2]
	

func polar(angle, radius):
	return Vector2(radius * cos(angle), radius * sin(angle))

func inv(vec):
	return Vector2(-vec.x, -vec.y)

