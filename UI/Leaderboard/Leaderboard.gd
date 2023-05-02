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
	NetworkManager.connect("leaderboard", Callable(self, "_on_network_manager_leaderboard"))
	NetworkManager.get_leaderboard()
	$MarginContainer/VBoxContainer/Panel/Control/LoadingPath/AnimationPlayer.play("spinner")

func _on_network_manager_leaderboard(leaders, player_position):
	$MarginContainer/VBoxContainer/Panel/Control/LoadingPath.visible = false
	print('_on_network_manager_leaderboard')
	print(leaders)
	print(player_position)
	
	for i in leaders.size():
		var leader = leaders[i]
		var entry = ScoreEntry.instantiate()
		entry.rank = i + 1
		entry.player = leader["name"]
		entry.score = leader["score"]
		$MarginContainer/VBoxContainer/Panel/VBox/ScrollContainer/VBoxContainer.add_child(entry)

func _on_MainMenu_pressed():
	Session.click()
	Session.main_menu()


func _on_Replay_pressed():
	Session.click()
	Session.start_game()
