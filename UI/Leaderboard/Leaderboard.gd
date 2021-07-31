extends ScrollContainer

export (PackedScene) var ScoreEntry


class MyCustomSorter:
	static func sort_ascending(a, b):
		if float(a["price"]) > float(b["price"]):
			return true
		return false


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the leaderboard from ddb
	$VBoxContainer/HTTPRequest.request("https://cqdzwos026.execute-api.eu-west-1.amazonaws.com/items")
	
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	
	var json = JSON.parse(body.get_string_from_utf8())
	
	var scores = json.result["Items"]
	scores.sort_custom(MyCustomSorter, "sort_ascending")
	for elt in scores:
		var entry = ScoreEntry.instance()
		entry.text = "Player %s got %s" % [elt["name"], elt["price"]]
		$VBoxContainer.add_child(entry)
		


func _on_MainMenu_pressed():
	Session.main_menu()


func _on_Replay_pressed():
	Session.restart_game()
