extends Node

export (String, FILE, "*.tscn") var game_path = "res://Game/GameMaster.tscn"
export (String, FILE, "*.tscn") var main_menu_path = "res://UI/MainMenu/MainMenu.tscn"
export (String, FILE, "*.tscn") var leaderboard_path = "res://UI/Leaderboard/Leaderboard.tscn"


var sounds = []
# mute while dev
var mute = false

func _ready():

	if not OS.has_feature("release"):
		if mute:
			AudioServer.set_bus_mute(0, true)
	sounds.append(preload("res://assets/audio/taunts/taunt1.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt2.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt3.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt4.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt5.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt6.mp3"))
	randomize()
	$BackgroundMusic.play()

	
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
	$ClickSound.play()
	unpause()
	get_tree().change_scene(game_path)
	
func leaderboard():
	$ClickSound.play()
	unpause()
	get_tree().change_scene(leaderboard_path)
	
func main_menu():
	$ClickSound.play()
	unpause()
	get_tree().change_scene(main_menu_path)
	
func lose():
	sounds.shuffle()
	$LostSound.stream = sounds.front()
	$LostSound.play()
	
	get_tree().paused = true
	$PauseMenu.set_visible_to(false)
	$LoseMenu.set_visible_to(true)


func submit_score(score, name):
	var id = str(score) + name + str(randi())
	var error = $HTTPSession.request("https://a6yspcizd0.execute-api.eu-west-1.amazonaws.com/add/{id}/{name}/{score}".format({"id":id,"name":name,"score":score}))


func _on_HTTPSession_request_completed(result, response_code, headers, body):
	unpause()
	get_tree().change_scene(leaderboard_path)

