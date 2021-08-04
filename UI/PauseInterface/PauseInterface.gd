extends Control


signal pressed


func _on_Button_pressed():
	SoundManager.play_click()
	emit_signal("pressed")
