extends Control


signal pressed


func _on_Button_pressed():
	emit_signal("pressed")
