extends CanvasLayer

var resume = false

var pausebutton

func _ready():
	pass

	
func resume():
	resume = true
	OS.set_time_scale(1)
	queue_free()


func _on_Resume_pressed():
	resume()


func _on_Reset_pressed():
	resume()
	globals.current_level.reset()


func _on_Quit_pressed():
	get_tree().quit()
