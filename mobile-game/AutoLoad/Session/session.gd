extends Node

@export_file("*.tscn") var game_path = "res://Game/GameMaster.tscn"
@export_file("*.tscn") var main_menu_path = "res://UI/MainMenu/MainMenu.tscn"
@export_file("*.tscn") var leaderboard_path = "res://UI/Leaderboard/Leaderboard.tscn"
@export_file("*.tscn") var settings_path = "res://Scenes/Menus/Settings/Settings.tscn"

var read_leaderboard_from_memory: bool = false
var in_memory_leaderboard: Dictionary

func _ready():
	randomize()
	
func pause_menu():
	$PauseMenu.set_visible_to(true)
	$LoseMenu.set_visible_to(false)

func remove_menus():
	$LoseMenu.set_visible_to(false)
	$PauseMenu.set_visible_to(false)

func start_game():
	Constants.lives = Constants.start_lives
	Constants.score = 0
	remove_menus()
	get_tree().change_scene_to_file(game_path)
	
func leaderboard():
	remove_menus()
	get_tree().change_scene_to_file(leaderboard_path)
	
func settings():
	get_tree().change_scene_to_file(settings_path)
	
func main_menu():
	remove_menus()
	get_tree().change_scene_to_file(main_menu_path)
	
func lose_menu():	
	$PauseMenu.set_visible_to(false)
	$LoseMenu.set_visible_to(true)

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
