extends RigidBody2D

const w = 128
const h = 128

const no = 64
const rows = 2
const columns = 32

var start_pos
var end_pos
var speed
var angle

var dispatched = false

func _ready():
	set_random_asteroid_image()
	
	start_pos = get_pos()
	set_process(true)
	
func set_speed(s):
	speed = s

func set_goal(pos):
	end_pos = pos
	
func _integrate_forces(state):
	var v = get_linear_velocity()
	var angle = atan2(v.x, v.y)
	set_rot(angle)

func _process(delta):
	if end_pos == null or !dispatched: return
	var cur_angle = atan2(end_pos.y - get_pos().y, end_pos.x - get_pos().x)
	
	var diff = cur_angle - angle
	if diff > PI: cur_angle -= 2*PI
	if diff < PI: cur_angle += 2*PI
	
	if abs(diff) > PI:
		reset()

func reset():
	set_linear_velocity(Vector2(0, 0))
	set_pos(start_pos)
	dispatched = false
	
func dispatch():
	angle = atan2(end_pos.y - start_pos.y, end_pos.x - start_pos.x)
	set_linear_velocity(polar(angle, speed))
	dispatched = true
	
	
func set_random_asteroid_image():
	
	randomize()
	var sprite = find_node("Sprite")
	var asteroid_idx = randi() % (no-1)
	var column = asteroid_idx
	var row = 0
	while column > columns-1:
		row += 1
		column -= columns
	
	var x = column * w
	var y = row * h
	sprite.set_region_rect(Rect2(x, y, w, h))
	

func polar(angle, radius):
	return Vector2(radius * cos(angle), radius * sin(angle))

func _on_ExitButton_pressed():
	pass # replace with function body
