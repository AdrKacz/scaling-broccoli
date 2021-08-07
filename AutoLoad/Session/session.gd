extends Node

export (String, FILE, "*.tscn") var game_path = "res://Game/GameMaster.tscn"
export (String, FILE, "*.tscn") var main_menu_path = "res://UI/MainMenu/MainMenu.tscn"
export (String, FILE, "*.tscn") var leaderboard_path = "res://UI/Leaderboard/Leaderboard.tscn"



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
	Constants.score = 0
	Constants.level = 0
	Constants.combo = 0
	SoundManager.play_click()
	unpause()
	get_tree().change_scene(game_path)
	
func leaderboard():
	SoundManager.play_click()
	unpause()
	get_tree().change_scene(leaderboard_path)
	
func main_menu():
	SoundManager.play_click()
	unpause()
	get_tree().change_scene(main_menu_path)
	
func lose():
	SoundManager.play_lost()
	
	get_tree().paused = true
	$PauseMenu.set_visible_to(false)
	$LoseMenu.set_visible_to(true)


func submit_score(score, name):
	var id = str(score) + name + str(randi())
	var error = $HTTPSession.request("https://a6yspcizd0.execute-api.eu-west-1.amazonaws.com/add/{id}/{name}/{score}".format({"id":id,"name":name,"score":score}))


func _on_HTTPSession_request_completed(result, response_code, headers, body):
	unpause()
	get_tree().change_scene(leaderboard_path)

