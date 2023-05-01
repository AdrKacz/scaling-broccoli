extends Node

@export_file("*.tscn") var game_path = "res://Game/GameMaster.tscn"
@export_file("*.tscn") var main_menu_path = "res://UI/MainMenu/MainMenu.tscn"
@export_file("*.tscn") var leaderboard_path = "res://UI/Leaderboard/Leaderboard.tscn"
@export_file("*.tscn") var settings_path = "res://Scenes/Menus/Settings/Settings.tscn"

func _ready():
	randomize()
	NetworkManager.connect("insert", Callable(self, "_on_NetworkManager_insert"))
	
func pause_with_opacity():
	get_tree().paused = true
	$PauseMenu.set_visible_to(true)

func unpause():
	$LoseMenu.set_visible_to(false)
	$PauseMenu.set_visible_to(false)
	get_tree().paused = false

func start_game():
	Constants.lives = Constants.start_lives
	Constants.score = 0
	unpause()
	get_tree().change_scene_to_file(game_path)
	
func leaderboard():
	unpause()
	get_tree().change_scene_to_file(leaderboard_path)
	
func settings():
	get_tree().change_scene_to_file(settings_path)
	
func main_menu():
	unpause()
	get_tree().change_scene_to_file(main_menu_path)
	
func lose():	
	get_tree().paused = true
	$PauseMenu.set_visible_to(false)
	$LoseMenu.set_visible_to(true)


func submit_score(score, player_name):
	NetworkManager.start_insert(score, player_name)


func _on_NetworkManager_insert(_result):
	unpause()
	get_tree().change_scene_to_file(leaderboard_path)

var vibration_on: bool = true
const LIGHT_HAPTIC_FEEDBACK: int = 4
const MEDIUM_HAPTIC_FEEDBACK: int = 8
func light_haptic_feedback():
	if vibration_on:
		Input.vibrate_handheld(LIGHT_HAPTIC_FEEDBACK)

func medium_haptic_feedback():
	if vibration_on:
		Input.vibrate_handheld(MEDIUM_HAPTIC_FEEDBACK)

func click():
	AudioManager.play_sound_effects(AudioManager.SOUND_EFFECTS.CLICK)
	light_haptic_feedback()

func tap():
	AudioManager.play_sound_effects(AudioManager.SOUND_EFFECTS.TAP)
	medium_haptic_feedback()
