extends Node2D


func _ready():
	remove_child(find_node("Placeholder"))
	var sc = get_scale()
	var side = min(sc.x, sc.y)
	side = min(200, side)
	
	var field = preload("res://scenes/Asteroid_Field.scn")
	var f = field.instance()
	f.set_pos(Vector2(0, 0))
	f.resize(side, side)
	
	add_child(f)
