extends Control

@export var ComboScene: PackedScene

signal score
signal miss
signal wrong
signal skip
signal neutral_hit
signal paused_changed

# Used by GameMaster when it needs to know the player tap during paused Game
# 	- When you completed a card, the Game paused, the GameMaster wants to know when to init the new card
var emit_neutral_hit: bool = false

var paused: bool:
	get:
		return $SwapBackgroundTimer.paused
	set(value):
		$SwapBackgroundTimer.paused = value
		emit_signal("paused_changed")
		
var character_visible: bool:
	get:
		return $Character.visible
	set(value):
		$Character.visible = value

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
		$MarginContainer/Background.material.set_shader_parameter('color', Constants.State[value])
		$MarginContainer/Background.material.set_shader_parameter('reflection_color', Constants.State[value])
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
	
func update_background_image(path: String):
	$MarginContainer/Background.set_texture(load(path))
	
func show_background_image():
	$MarginContainer/Background.material.set_shader_parameter('use_cracks_and_glass', false)
	$MarginContainer/Background.material.set_shader_parameter('use_color', false)
	
func hide_background_image():
	$MarginContainer/Background.material.set_shader_parameter('use_cracks_and_glass', true)
	$MarginContainer/Background.material.set_shader_parameter('use_color', true)
	
var background_abberation: float:
	get:
		return $MarginContainer/Background.material.get_shader_parameter('abberation_spread')
	set(value):
		$MarginContainer/Background.material.set_shader_parameter('abberation_spread', value)

func _on_character_tap():
	# Hitted
	if emit_neutral_hit and paused:
		emit_signal("neutral_hit")
		return
		
	if paused:
		paused = false # (Re)start the game
	
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
		# Let the player breath after failure, force next match
		paused = true
		$Character.state = background_state
		Constants.state_matches = true

func _on_swap_background_timer_timeout():
	if Constants.state_matches:
		emit_signal("miss")
		# Let the player breath after failure, force next match
		paused = true
		update_background_state()
		$Character.state = background_state
		Constants.state_matches = true
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
		
func update_crack(circles: int, lines: int) -> void:
	$MarginContainer/Background.material.set_shader_parameter('current_number_of_circles', circles)
	$MarginContainer/Background.material.set_shader_parameter('number_of_lines', lines)

func generate_crack(final_number_of_circles: int, minimum_circle_radius: float = 0.15, maximum_circle_radius: float = 0.5) -> void:
	$MarginContainer/Background.material.set_shader_parameter('minimum_circle_radius', minimum_circle_radius)
	$MarginContainer/Background.material.set_shader_parameter('maximum_circle_radius', maximum_circle_radius)
	$MarginContainer/Background.material.set_shader_parameter('final_number_of_circles', final_number_of_circles)
	$MarginContainer/Background.material.set_shader_parameter('seed', randf())
	
func reset_crack() -> void:
	$MarginContainer/Background.material.set_shader_parameter('current_number_of_circles', 0)
	$MarginContainer/Background.material.set_shader_parameter('number_of_lines', 0)
