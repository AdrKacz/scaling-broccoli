extends Control

export (PackedScene) var ScoreEntry


class MyCustomSorter:
	static func sort_ascending(a, b):
		if float(a["price"]) > float(b["price"]):
			return true
		return false


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the leaderboard from ddb
	$HTTPRequest.request("https://cqdzwos026.execute-api.eu-west-1.amazonaws.com/items")
	
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	
	var json = JSON.parse(body.get_string_from_utf8())
	
	var scores = json.result["Items"]
	scores.sort_custom(MyCustomSorter, "sort_ascending")
	var i = 1
	for elt in scores:
		var entry = ScoreEntry.instance()
		entry.rank = str(i)
		entry.player = elt["name"]
		entry.score = str(elt["price"])
		$MarginContainer/VBoxContainer/ScrollContainer/VBox.add_child(entry)
		i += 1


func _on_MainMenu_pressed():
	Session.main_menu()


func _on_Replay_pressed():
	Session.start_game()
