extends CanvasLayer

func _on_Continue_pressed():
	Session.click()
	get_tree().paused = false
	visible = false

func _on_MainMenu_pressed():
	Session.click()
	get_tree().paused = false
	visible = false
	Session.change_node_to(Session.MainMenu)

func _on_Restart_pressed():
	Session.click()
	get_tree().paused = false
	visible = false
	Session.change_node_to(Session.GameMaster)
