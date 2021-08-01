extends Node

export (String, FILE, "*.tscn") var game_path = "res://Game/GameMaster.tscn"
export (String, FILE, "*.tscn") var main_menu_path = "res://UI/MainMenu/MainMenu.tscn"
export (String, FILE, "*.tscn") var leaderboard_path = "res://UI/Leaderboard/Leaderboard.tscn"


onready var root = get_tree().get_root()
var pause_menu = null



func _ready():
	randomize()

	
func pause_with_opacity():
	get_tree().paused = true
	$PauseMenu.set_visible_to(true)

func unpause():
	$LoseMenu.set_visible_to(false)
	$PauseMenu.set_visible_to(false)
	get_tree().paused = false

func start_game():
	unpause()
	get_tree().change_scene(game_path)
	
func leaderboard():
	unpause()
	get_tree().change_scene(leaderboard_path)
	
func main_menu():
	unpause()
	get_tree().change_scene(main_menu_path)
	
func lose(to, score):
	$LoseMenu.score = score
	
	get_tree().paused = true
	$PauseMenu.set_visible_to(false)
	$LoseMenu.set_visible_to(true)


func submit_score(score, name):
	var error = $HTTPSession.request("https://cqdzwos026.execute-api.eu-west-1.amazonaws.com/items", ["Content-Type: application/json"], false, 2, JSON.print({"id": str(score) + name + str(randi()), "price": score, "name": name}))



func _on_HTTPSession_request_completed(result, response_code, headers, body):
	unpause()
	get_tree().change_scene(leaderboard_path)
