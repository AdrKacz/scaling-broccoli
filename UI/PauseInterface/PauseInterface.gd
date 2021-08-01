extends Control


signal pressed


func _on_Button_pressed():
	$ClickSound.play()
	emit_signal("pressed")
