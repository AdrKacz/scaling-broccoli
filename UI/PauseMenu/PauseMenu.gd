extends CanvasLayer


func set_visible_to(value):
	$Control.visible = value

func _on_Continue_pressed():
	Session.unpause()


func _on_MainMenu_pressed():
	Session.main_menu()


func _on_Restart_pressed():
	Session.start_game()
