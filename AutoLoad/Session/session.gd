extends Node

export (String, FILE, "*.tscn") var game_path = "res://Game/Game.tscn"
export (String, FILE, "*.tscn") var main_menu_path = "res://UI/MainMenu/MainMenu.tscn"
export (String, FILE, "*.tscn") var leaderboard_path = "res://UI/Leaderboard/Leaderboard.tscn"
export (PackedScene) var PauseMenu = preload("res://UI/PauseMenu/PauseMenu.tscn")
export (PackedScene) var LoseMenu = preload("res://UI/LoseMenu/LoseMenu.tscn")


onready var root = get_tree().get_root()
var pause_menu = null


func _ready():
	randomize()
	print("init")
	#$HTTPRequest.connect("request_completed", self, "_on_request_completed")

	
func pause_with_opacity():
	get_tree().paused = true
	pause_menu = PauseMenu.instance()
	pause_menu.show()
	root.get_child(root.get_child_count() - 1).add_child(pause_menu)

func unpause():
	get_tree().queue_delete(pause_menu)
	get_tree().paused = false

func start_game():
	get_tree().paused = false
	get_tree().change_scene(game_path)
	
func restart_game():
	get_tree().paused = false
	get_tree().change_scene(game_path)
	
func leaderboard():
	get_tree().paused = false
	get_tree().change_scene(leaderboard_path)
	
func main_menu():
	get_tree().paused = false
	get_tree().change_scene(main_menu_path)
	
func lose():
	get_tree().paused = true
	var lose_menu = LoseMenu.instance()
	lose_menu.show()
	root.get_child(root.get_child_count() - 1).add_child(lose_menu)

func submit_score(score, name):
	var error = $HTTPSession.request("https://cqdzwos026.execute-api.eu-west-1.amazonaws.com/items", ["Content-Type: application/json"], false, 3, JSON.print({"id": str(score) + name + str(randi()), "price": score, "name": name}))



func _on_HTTPSession_request_completed(result, response_code, headers, body):
	get_tree().paused = false
	get_tree().change_scene(leaderboard_path)
