extends Control
signal on_screen

func _ready():
	emit_signal("on_screen")

func _on_play_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster)

func _on_leaderboard_pressed():
	Session.click()
	Session.change_node_to(Session.LeaderboardMenu)

func _on_texture_button_pressed():
	Session.click()
	Session.change_node_to(Session.SettingsMenu)
