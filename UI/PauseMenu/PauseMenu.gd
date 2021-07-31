extends Control



func _on_Continue_pressed():
	Session.unpause()


func _on_Main_menu_pressed():
	Session.main_menu()


func _on_Restart_pressed():
	Session.start_game()
