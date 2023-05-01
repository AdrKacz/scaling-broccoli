extends Control

func _on_play_pressed():
	Session.click()
	Session.start_game()

func _on_leaderboard_pressed():
	Session.click()
	Session.leaderboard()

func _on_texture_button_pressed():
	Session.click()
	Session.settings()
