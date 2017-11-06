
extends Node2D

var elapsed

func _ready():
	elapsed = 0
	set_process(true)
	
func _process(delta):
	elapsed += delta
	if (elapsed > 4.0):
		get_tree().change_scene("res://orbit_hopper.scn")


