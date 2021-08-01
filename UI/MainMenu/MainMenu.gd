extends Control


func _on_Play_pressed():
	Session.start_game()



func _on_Leaderboard_pressed():
	Session.leaderboard()
