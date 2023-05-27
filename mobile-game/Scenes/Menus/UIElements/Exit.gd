extends Control

func _on_exit_button_pressed():
	Session.click()
	Session.change_node_to(Session.MainMenu)
