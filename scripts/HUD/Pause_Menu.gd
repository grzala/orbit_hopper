extends CanvasLayer

var resume = false

var pausebutton

func _ready():
	pass

	
func resume():
	resume = true
	OS.set_time_scale(1)
	queue_free()


func _on_Resume_button_up():
	resume()
