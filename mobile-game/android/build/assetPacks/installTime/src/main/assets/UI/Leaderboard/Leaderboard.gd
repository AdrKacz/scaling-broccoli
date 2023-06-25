extends CanvasLayer

signal on_screen

@export var ScoreEntry: PackedScene
@export var OwnScoreEntry: PackedScene

class MyCustomSorter:
	static func sort_ascending(a, b):
		if float(a["score"]) > float(b["score"]):
			return true
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("on_screen")
	if validate_memory_leaderboard():
		# get leaderboard from memory
		var leaders = Session.in_memory_leaderboard.get("leaders")
		var player_position = Session.in_memory_leaderboard.get("position")
		display_leaderboard(leaders, player_position)
	else:
		# get leaderboard from network
		NetworkManager.connect("leaderboard", Callable(self, "_on_network_manager_leaderboard"))
		NetworkManager.get_leaderboard()
		$MarginContainer/VBoxContainer/CenterContainer/Loader.spin()

func validate_memory_leaderboard() -> bool:
	if not Session.read_leaderboard_from_memory:
		return false
	Session.read_leaderboard_from_memory = false
	if Session.in_memory_leaderboard == null:
		return false
	if Session.in_memory_leaderboard.get("leaders") == null:
		return false
	if Session.in_memory_leaderboard.get("position") == null:
		return false
	return true
	
func add_entry(Entry: PackedScene, player_position: Variant, player_name, score):
	var entry = Entry.instantiate()
	entry.rank_string = str(player_position)
	entry.player = player_name
	entry.score = score
	$MarginContainer/VBoxContainer/VBoxContainer.add_child(entry)

func display_leaderboard(leaders, player_position):
	for i in leaders.size():
		var rank = i + 1
		var player_name = leaders[i]["name"]
		var score = leaders[i]["score"]
		if i + 1 == player_position:
			add_entry(OwnScoreEntry, rank, player_name, score)
		else:
			add_entry(ScoreEntry, rank, player_name, score)
	
	if validate_last_submission():
		if player_position == 0:
			add_entry(
				OwnScoreEntry,
				"Infinity",
				NetworkManager.last_submitted_name,
				NetworkManager.last_submitted_score)
		elif player_position > leaders.size():
			add_entry(
				OwnScoreEntry,
				player_position,
				NetworkManager.last_submitted_name,
				NetworkManager.last_submitted_score)
	
	$MarginContainer/VBoxContainer/CenterContainer/Loader.stop()
	$MarginContainer/VBoxContainer/CenterContainer.visible = false
	$MarginContainer/VBoxContainer/VBoxContainer.visible = true

func validate_last_submission() -> bool:
	if NetworkManager.last_submitted_name == null:
		return false
	if NetworkManager.last_submitted_score == null:
		return false
	return true

func _on_network_manager_leaderboard(leaders, player_position):
	display_leaderboard(leaders, player_position)
	
func _on_play_button_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster)
