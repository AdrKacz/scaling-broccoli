extends Control

@export var ComboScene: PackedScene

signal score
signal miss
signal wrong
signal skip

var character_state: int = 0:
	get:
		return background_state
	set(value):
		$Character.state = value
		Session.character_state = value
		character_state = value

var background_state: int = 0:
	get:
		return background_state
	set(value):
		$Background.color = Constants.State[value]
		Session.background_state = background_state
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
	character_state = StateManager.get_character_next_state($Character.state)
	
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
	else:
		emit_signal("skip")
	update_background_state()
	
# Used for debugging, to comment out
# func _input(event):
# 	if event is InputEventKey and event.keycode == KEY_SPACE and event.is_pressed() and not event.is_echo():
# 		Session.tap()
# 		_on_character_tap()

func _on_gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() :
		Session.tap()
		_on_character_tap()
