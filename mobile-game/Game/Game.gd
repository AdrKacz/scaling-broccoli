extends Control

@export var ComboScene: PackedScene

signal score
signal miss
signal wrong

var background_state: int = 0:
	get:
		return background_state
	set(value):
		$Background.color = Constants.State[value]
		background_state = value
		
func _ready():
	# center character on screen
	$Character.position = get_parent_area_size() / 2
	
	# get random state
	var state = Constants.StateEnum.values().pick_random()
	$Character.state = state
	background_state = state
	Constants.state_matches = true

func update_character_state():
	$Character.state = StateManager.get_character_next_state($Character.state)
	
func update_background_state():
	background_state = StateManager.get_background_next_state(background_state, $Character.state)
	$SwapBackgroundTimer.start(Constants.swap_delta)

func _on_character_tap():
	# Hitted
	if Constants.state_matches:
		$Character.pulse()
		emit_signal("score")
		# Update background and character
		update_character_state()
		update_background_state()
	# Missed
	else:
		$Character.shake()
		emit_signal("wrong")

func _on_swap_background_timer_timeout():
	if Constants.state_matches:
		emit_signal("miss")
	update_background_state()
