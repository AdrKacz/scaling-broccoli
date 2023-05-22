extends CanvasLayer
signal on_screen

func _ready():
	if Constants.remaining_lives == 0:
		$Control/MarginContainer/CenterContainer/VBoxContainer/Play.queue_free()
	emit_signal("on_screen")

func _on_exit_button_pressed():
	Session.click()
	Session.change_node_to(Session.MainMenu)

func _on_play_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster, {
		"is_challenge": true,
		"end_challenge_condition": func () -> bool:
			if Constants.combos_strike >= 20:
				return true
			return false
	})
