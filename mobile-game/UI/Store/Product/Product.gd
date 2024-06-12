extends PanelContainer
signal pressed

func _on_button_pressed():
	Session.click()
	emit_signal("pressed")
