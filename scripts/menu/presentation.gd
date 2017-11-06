extends Node2D

onready var asteroids = find_node("asteroid spawn").get_children()

func _ready():
	
	#fields
	var field = find_node("asteroids")
	var types = [4, 2, 1, 4, 5, 1, 2, 3, 5, 2, 4, 1, 2]
	
	var i = 0
	for c in field.get_children():
		c.set_type(types[i])
		i += 1
	
	#small asteroids
	for i in range(asteroids.size()):
		var a = asteroids[i]
		a.set_speed(300)
		a.set_goal(Vector2(a.get_pos().x, -850))
		a.dispatch()
		
	set_process(true)
		
func _process(delta):
	var dispatch_ready = true
	for a in asteroids:
		if a.dispatched:
			dispatch_ready = false
			break
	
	if dispatch_ready:
		for a in asteroids: a.dispatch()