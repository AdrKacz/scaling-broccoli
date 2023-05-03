extends CanvasLayer


func set_visible_to(value):
	$Control.visible = value
	get_tree().paused = value

func _on_Continue_pressed():
	Session.click()
	Session.remove_menus()


func _on_MainMenu_pressed():
	Session.click()
	Session.main_menu()


func _on_Restart_pressed():
	Session.click()
	Session.start_game()
