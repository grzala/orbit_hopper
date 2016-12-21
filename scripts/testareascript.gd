
extends Area2D

var col
var aiming
var pos1
var pos2

const MAX_POWER = 5000
const MAX_DIST = 280

var probe = preload("res://scenes/Probe.scn")
var aim_line

#mouse or touchscreen?
var mobile 

func _ready():
	set_process_input(true)
	set_process(true)
	
	col = get_child(0)
	aim_line = get_parent().find_node("aimLine")
	
	mobile = false
	aiming = false
	pos1 = null
	pos2 = null
	
func _process(delta):
	aim()
	update()
	
func aim():
	#if not aiming, ensure everything is null and do not execute
	if !aiming: 
		pos1 = null
		pos2 = null
		return
	
	#slow motion, implement this in level scipt
	OS.set_time_scale(0.2)
	
	if !mobile: #mobile pos2 is updated by screen dragged
		pos2 = get_viewport().get_mouse_pos()
		
	aim_line.end = pos2

func release():
	#do nothing
	if pos1 == null or pos2 == null: return
	
	OS.set_time_scale(1)
	var ship = get_node("/root/orbit_hopper/G_Objects_Field/Ship")
	
	#find power and angle
	var dist = pos1.distance_to(pos2)
	dist = min(dist, MAX_DIST)
	#dist / MAX_DIST = power / MAX_POWER
	var power = (dist * MAX_POWER) / MAX_DIST
	var angle = atan2(pos2.y - pos1.y, pos2.x - pos1.x)
	
	#initialize new probe
	var vec = polar(angle, power)
	vec = -vec
	var probe = preload("res://scenes/Probe.scn").instance()
	probe.accelerate(vec)
	probe.set_vel(ship.get_vel())
	probe.set_pos(ship.get_pos())
	
	get_node("/root/orbit_hopper/G_Objects_Field").add_child(probe)
	
	#reset aiming
	pos1 = null
	pos2 = null
	get_parent().find_node("aimLine").start = null
	get_parent().find_node("aimLine").end = null 
	
func _input(event):
	#desktop
	if event.type == InputEvent.SCREEN_DRAG:
		mobile = true
		if evt_in_bounds(event):
			aiming = true
			if pos1 == null:
				pos1 = event.pos
			pos2 = event.pos
			get_parent().find_node("aimLine").start = pos1
	
	#mobile
	elif event.is_action_pressed("ui_touch"):
		mobile = false
		if evt_in_bounds(event):
			aiming = true
			if pos1 == null:
				pos1 = event.pos
			get_parent().find_node("aimLine").start = pos1
	
	#released
	elif event.is_action_released("ui_touch"):
		release()
		aiming = false

func evt_in_bounds(event):
	var pos = col.get_pos()
	var extents = col.get_shape().get_extents()
	
	var minx = pos.x - extents.x
	var miny = pos.y - extents.y
	var maxx = pos.x + extents.x
	var maxy = pos.y + extents.y
	var mousepos = event.pos
	
	return mousepos.x > minx and mousepos.x < maxx and mousepos.y > miny and mousepos.y < maxy

func polar(angle, radius):
	return Vector2(radius * cos(angle), radius * sin(angle))
