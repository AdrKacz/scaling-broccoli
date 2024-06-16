extends Node
signal update_active_shields(value: int)
signal update_show_countdown(value: bool)

@export var GameMaster: PackedScene
@export var SettingsMenu: PackedScene

var character_state: int
var background_state: int

var main_node: MainNode

func _ready():
	randomize()
	active_shields = min(3, Memory.shields)
	
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
	
var active_shields: int:
	get:
		return active_shields
	set(value):
		active_shields = clamp(value, 0, 3)
		emit_signal("update_active_shields", active_shields)
		
var show_countdown: bool = false:
	get:
		return show_countdown
	set(value):
		show_countdown = value
		emit_signal("update_show_countdown", show_countdown)
	
