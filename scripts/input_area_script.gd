
extends Area2D

var col
var aiming
var pos1
var pos2

const MAX_POWER = 70
const MIN_POWER = 15
var MAX_DIST = OS.get_window_size().width * 0.5 #60% of screen

const MIN_TIME_SCAlE = 0.05
const TIME_SCALE_DELTA = 2

var power
var angle
var vec

var slowdown


var probe = preload("res://scenes/Probe.scn")
onready var ship = get_node("/root/orbit_hopper/G_Objects_Field/Ship")
var aim_line

#mouse or touchscreen?
var mobile 

var old_probe = null

func _ready():
	set_process_input(true)
	set_process(true)
	
	col = get_child(0)
	aim_line = get_parent().find_node("Aim_Line")
	
	mobile = false
	aiming = false
	pos1 = null
	pos2 = null
	
func _process(delta):
	if delta == 0 or OS.get_time_scale() == 0: return #paused
	
	if aiming:
		if OS.get_time_scale() > MIN_TIME_SCAlE:
			OS.set_time_scale(OS.get_time_scale() - TIME_SCALE_DELTA * delta)
	else:
		if OS.get_time_scale() < 1:
			OS.set_time_scale(OS.get_time_scale() + TIME_SCALE_DELTA * delta)
	
	aim()
	if slowdown:
		var probe = get_node("/root/orbit_hopper/G_Objects_Field/Probe")
		if probe != null:
			probe.slow_down()
	
	update()
	
func aim():
	#if not aiming, ensure everything is null and do not execute
	if !aiming: 
		pos1 = null
		pos2 = null
		return
	
	#slow motion, implement this in level scipt
	#OS.set_time_scale(0.2)
	
	if !mobile: #mobile pos2 is updated by screen dragged
		pos2 = get_viewport().get_mouse_pos()
	
	#find power and angle
	var dist = pos1.distance_to(pos2)
	dist = min(dist, MAX_DIST)
	
	#dist / MAX_DIST = power / MAX_POWER //proporcje
	power = ((dist * MAX_POWER) / MAX_DIST)
	power = max(power, MIN_POWER)
	angle = atan2(pos2.y - pos1.y, pos2.x - pos1.x)
	vec = polar(angle, power)
	vec = -vec
	
	aim_line.end = pos2
	aim_line.vec = vec
	aim_line.ship_pos = ship.get_pos()
	aim_line.ship_vel = ship.get_linear_velocity()

func release():
	#do nothing
	if pos1 == null or pos2 == null: return
	
	OS.set_time_scale(1)
	
	var probe = preload("res://scenes/Probe.scn").instance()
	probe.set_name("Probe")
	probe.set_linear_velocity(vec)
	probe.set_linear_velocity(probe.get_linear_velocity() + ship.get_linear_velocity())
	probe.set_pos(ship.get_pos())
	
	var field = get_node("/root/orbit_hopper/G_Objects_Field")
	if old_probe != null: field.remove_child(old_probe)
	field.add_child(probe)
	old_probe = probe
	
	clean_aim()

func clean_aim():
	#reset aiming
	pos1 = null
	pos2 = null
	aim_line.start = null
	aim_line.end = null 
	aim_line.ship_pos = null
	aim_line.ship_vel = null
	aim_line.vec = null
	
func _input(event):
	#mobile
	if event.type == InputEvent.SCREEN_DRAG:
		mobile = true
		if evt_in_bounds(event):
			aiming = true
			if pos1 == null:
				pos1 = event.pos
			pos2 = event.pos
			aim_line.start = pos1
	
	#desktop
	elif event.is_action_pressed("ui_touch"):
		mobile = false
		if evt_in_bounds(event):
			aiming = true
			if pos1 == null:
				pos1 = event.pos
			aim_line.start = pos1
		
	elif event.is_action_pressed("ui_cancel_shot"):
		OS.set_time_scale(1)
		aiming = false
		clean_aim()
		
	if event.is_action_pressed("ui_select"):
		slowdown = true
	elif event.is_action_released("ui_select"):
		slowdown = false
		
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
