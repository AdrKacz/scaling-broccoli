extends CanvasLayer
signal on_screen

func _ready():
	emit_signal("on_screen")

func _on_exit_button_pressed():
	Session.click()
	Session.change_node_to(Session.MainMenu)


func _on_play_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster)
