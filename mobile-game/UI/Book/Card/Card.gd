extends MarginContainer
signal pressed

func _on_texture_button_pressed():
	emit_signal("pressed")
