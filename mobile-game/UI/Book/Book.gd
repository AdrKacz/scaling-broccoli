extends CanvasLayer
signal exit

func _on_exit_texture_button_pressed():
	emit_signal("exit")

func _on_card_pressed():
	# TODO: Change texture of $CardFullScreen
	$CardFullScreen.visible = true

func _on_card_full_screen_pressed():
	$CardFullScreen.visible = false
