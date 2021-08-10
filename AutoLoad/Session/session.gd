extends Node

export (String, FILE, "*.tscn") var game_path = "res://Game/GameMaster.tscn"
export (String, FILE, "*.tscn") var main_menu_path = "res://UI/MainMenu/MainMenu.tscn"
export (String, FILE, "*.tscn") var leaderboard_path = "res://UI/Leaderboard/Leaderboard.tscn"



func _ready():
	randomize()
	NetworkManager.connect("insert", self, "_on_NetworkManager_insert")
	
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
	NetworkManager.insert(score, name)


func _on_NetworkManager_insert(result):
	unpause()
	get_tree().change_scene(leaderboard_path)

