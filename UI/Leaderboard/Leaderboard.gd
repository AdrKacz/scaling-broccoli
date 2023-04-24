extends Control

@export var ScoreEntry: PackedScene

class MyCustomSorter:
	static func sort_ascending(a, b):
		if float(a["score"]) > float(b["score"]):
			return true
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame # wait to have size working
	# Place spinner in the middle
	print(size, $MarginContainer/VBoxContainer/Panel/Control.size)
	$MarginContainer/VBoxContainer/Panel/Control/LoadingPath.position = $MarginContainer/VBoxContainer/Panel/Control.size / 2
	# Get the leaderboard from ddb
	NetworkManager.connect("scan", Callable(self, "_on_NetworkManager_scan"))
	NetworkManager.start_scan()
	$MarginContainer/VBoxContainer/Panel/Control/LoadingPath/AnimationPlayer.play("spinner")

func _on_NetworkManager_scan(scores):
	$MarginContainer/VBoxContainer/Panel/Control/LoadingPath.visible = false
	
	scores.sort_custom(Callable(MyCustomSorter, "sort_ascending"))
	var i = 1
	for elt in scores:
		var entry = ScoreEntry.instantiate()
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
