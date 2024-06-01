extends Control

signal clicked

func _on_exit_button_pressed():
	emit_signal("clicked")
