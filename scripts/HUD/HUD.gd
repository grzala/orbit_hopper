extends CanvasLayer

var action = null

func _ready():
	set_process(true)

func _process(delta):
	var pausemenu = find_node("Pause_Menu")
	if pausemenu != null and pausemenu.resume == true:
		pass

func _on_Pause_pressed():
	var paused = false
	var pmenu = null
	for c in get_children():
		if "pausebutton" in c:
			paused = true
			pmenu = c
			break
	
	if !paused:
		OS.set_time_scale(0)
		var pausemenu = preload("res://scenes/HUD/Pause_Menu.tscn").instance()
		add_child(pausemenu)
	
	else:
		pmenu.resume()
		action = "resume"
