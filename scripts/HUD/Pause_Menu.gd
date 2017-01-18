extends CanvasLayer

var resume = false

var pausebutton

func _ready():
	pass


func _on_Resume_button_down():
	resume()
	
func resume():
	resume = true
	OS.set_time_scale(1)
	queue_free()
