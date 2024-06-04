extends CanvasLayer
signal exit

func _on_exit_texture_button_pressed():
	emit_signal("exit")
