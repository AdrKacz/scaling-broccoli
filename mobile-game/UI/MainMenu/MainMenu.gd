extends CanvasLayer
signal on_screen

func _ready():
	emit_signal("on_screen")

func _on_leaderboard_button_pressed():
	Session.click()
	Session.change_node_to(Session.LeaderboardMenu)

func _on_settings_button_pressed():
	Session.click()
	Session.change_node_to(Session.SettingsMenu)

func _on_arcade_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster)


func _on_challenge_pressed():
	Session.click()
	Session.change_node_to(Session.ChallengeMenu)
