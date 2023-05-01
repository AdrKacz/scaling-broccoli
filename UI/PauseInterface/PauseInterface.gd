extends Control

signal pressed

func _on_Button_pressed():
	Session.click()
	emit_signal("pressed")
