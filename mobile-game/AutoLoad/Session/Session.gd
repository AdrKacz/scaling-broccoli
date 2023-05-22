extends Node

@export var MainMenu: PackedScene
@export var GameMaster: PackedScene
@export var LeaderboardMenu: PackedScene
@export var SettingsMenu: PackedScene
@export var LoseMenu: PackedScene
@export var ChallengeMenu: PackedScene
@export var LoseChallenge: PackedScene
@export var WinChallenge: PackedScene

var read_leaderboard_from_memory: bool = false
var in_memory_leaderboard: Dictionary

var main_node: MainNode

func _ready():
	randomize()
	
func assign_main_node(node: MainNode):
	# Must be called first by Main Node
	main_node = node
	
func change_node_to(scene: PackedScene, params: Dictionary = {}):
	main_node.change_node_to(scene, params)

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
