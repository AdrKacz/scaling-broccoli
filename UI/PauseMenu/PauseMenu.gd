extends CanvasLayer


func set_visible_to(value):
	$Control.visible = value

func _on_Continue_pressed():
	$ClickSound.play()
	Session.unpause()


func _on_MainMenu_pressed():
	$ClickSound.play()
	Session.main_menu()


func _on_Restart_pressed():
	$ClickSound.play()
	Session.start_game()
