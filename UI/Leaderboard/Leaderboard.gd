extends Control

export (PackedScene) var ScoreEntry


class MyCustomSorter:
	static func sort_ascending(a, b):
		if float(a["score"]) > float(b["score"]):
			return true
		return false


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the leaderboard from ddb
	NetworkManager.connect("scan", self, "_on_NetworkManager_scan")
	NetworkManager.scan()
	$Path2D/AnimationPlayer.play("spinner")
	
func _on_NetworkManager_scan(scores):
	$Path2D.visible = false
	
	scores.sort_custom(MyCustomSorter, "sort_ascending")
	var i = 1
	for elt in scores:
		var entry = ScoreEntry.instance()
		entry.rank = str(i)
		entry.player = elt["name"]
		entry.score = str(elt["score"])
		$MarginContainer/VBoxContainer/Panel/VBox/ScrollContainer/VBoxContainer.add_child(entry)
		i += 1


func _on_MainMenu_pressed():
	Session.main_menu()


func _on_Replay_pressed():
	SoundManager.play_click()
	Session.start_game()
