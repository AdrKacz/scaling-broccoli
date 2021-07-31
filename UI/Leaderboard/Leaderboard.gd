extends ScrollContainer

export (PackedScene) var ScoreEntry


class MyCustomSorter:
	static func sort_ascending(a, b):
		if float(a["price"]) > float(b["price"]):
			return true
		return false


# Called when the node enters the scene tree for the first time.
func _ready():
	# Gert the leaderboard from ddb
	$VBoxContainer/HTTPRequest.request("https://cqdzwos026.execute-api.eu-west-1.amazonaws.com/items")


func _on_Button_pressed():
	$VBoxContainer/HTTPRequest.request("https://cqdzwos026.execute-api.eu-west-1.amazonaws.com/items", ["Content-Type: application/json"], false, 3, JSON.print({"id":str(OS.get_unix_time())+","+str(randi()),"price":13,"name":"hahaha"}))
	#$VBoxContainer/HTTPRequest.request("https://cqdzwos026.execute-api.eu-west-1.amazonaws.com/items", ["Content-Type: application/json"], false, 3, JSON.print({"id":"22","price":12,"name":"hahaha"}))


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	
	var json = JSON.parse(body.get_string_from_utf8())
	
	var scores = json.result["Items"]
	scores.sort_custom(MyCustomSorter, "sort_ascending")
	for elt in scores:
		var entry = ScoreEntry.instance()
		entry.text = "Player %s got %s" % [elt["name"], elt["price"]]
		$VBoxContainer.add_child(entry)
		
		print(elt)
	print(json.result)
