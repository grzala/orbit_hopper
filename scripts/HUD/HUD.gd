extends CanvasLayer

var action = null

onready var fuel_label = find_node("Label")
const s1 = "Probe fuel:\n"
const s2 = "%"

func _ready():
	set_process(true)

func _process(delta):
	var pausemenu = find_node("Pause_Menu")
	if pausemenu != null and pausemenu.resume == true:
		pass
	
	update_fuel()

func update_fuel():
	var percent = ""
	if globals.current_probe == null or globals.current_probe.get("tank") == null:
		percent = "100"
	else:
		percent = (globals.current_probe.tank / globals.current_probe.max_tank) * 100
		percent = str(int(percent))
		
	var label = s1 + str(int(percent)) + s2
	fuel_label.set_text(label)

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
