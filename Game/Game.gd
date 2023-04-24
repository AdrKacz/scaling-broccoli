extends Control

@export var ComboScene: PackedScene

signal score
signal miss
signal wrong
signal no_combo_time_left

var background_state: int = 0:
	get:
		return background_state
	set(value):
		$Background.color = Constants.State[value]
		background_state = value

func _ready():
	$Character.state = StateManager.get_character_next_state()
	update_background_state()
	# Position node -- no need to update every frame, window size won't change in game
	print($Character.position, get_parent_area_size())
	$Character.position = get_parent_area_size() / 2
	$ComboTimer.position = get_parent_area_size() / 2
	
func setup():
	_ready()

func update_combo_time(new_value, delta):
	$ComboTimer.update_time(new_value, delta)

# Every time the player clicks
func _on_Character_click(state):
	print('Character Click')
	# He scored
	if $Character.state == background_state:
		emit_signal("score")
		# Update background and character
		$Character.state = StateManager.get_character_next_state()
		update_background_state()

	# He lost
	else:
		emit_signal("wrong")
		$Character.shake()

func update_background_state():
	background_state = StateManager.get_background_next_state(background_state, $Character.state)
	
func update_background_state_to(state):
	background_state = state
	
func update_character_state_to(state):
	$Character.state = state

func _on_ComboTimer_no_time_left():
	print("No time left for combo")
	emit_signal("no_combo_time_left")
