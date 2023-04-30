extends Control

func _on_play_pressed():
	Session.start_game()

func _on_leaderboard_pressed():
	Session.leaderboard()

func _on_texture_button_pressed():
	Session.settings()
