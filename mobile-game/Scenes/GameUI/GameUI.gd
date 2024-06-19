extends Control
signal shield_submitted(use_shield: bool)
signal continue_game
signal pause_game

@export var BonusText: PackedScene

var display_bonus_text_position_down: Vector2
var display_bonus_text_position_up: Vector2

func _ready():
	# get position for bonus text
	var computed_safe_area: Rect2 = $MarginContainer.computed_safe_area
	
	$Countdown.position = get_parent_area_size() / 2
	
	$Stars.position = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y * .05,
	)
	
	$IntroductionText.position = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y * .25,
	)

	display_bonus_text_position_down = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y * .8,
	)
	
	display_bonus_text_position_up = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y * .2,
	)
	
func _on_settings_button_pressed():
	Session.click()
	get_tree().paused = true
	$MarginContainer/UIControl/SettingsMarginContainer.visible = false
	$MarginContainer/Settings.visible = true
	
func _on_settings_exit():
	Session.click()
	get_tree().paused = false
	$MarginContainer/UIControl/SettingsMarginContainer.visible = true 
	$MarginContainer/Settings.visible = false
	
func remove_introduction_text():
	if find_child('IntroductionText', false):
		$IntroductionText.leave()

func display_bonus_text(text):
	var bonus_text = BonusText.instantiate()
	bonus_text.text = text
	# Assign base position
	if randi_range(0, 1) == 0:
		bonus_text.position = display_bonus_text_position_down
	else:
		bonus_text.position = display_bonus_text_position_up
	# Randomise position
	bonus_text.position += Vector2(randf_range(-64, 64), randf_range(-64, 64))
	add_child(bonus_text)


func _on_book_texture_button_pressed():
	Session.click()
	get_tree().paused = true
	$MarginContainer/UIControl/BookMarginContainer.visible = false
	$MarginContainer/Book.visible = true


func _on_book_exit():
	Session.click()
	get_tree().paused = false
	$MarginContainer/UIControl/BookMarginContainer.visible = true 
	$MarginContainer/Book.visible = false

func _on_store_texture_button_pressed():
	Session.click()
	get_tree().paused = true
	$MarginContainer/UIControl/StoreMarginContainer.visible = false
	$MarginContainer/Store.visible = true

func _on_store_exit():
	Session.click()
	get_tree().paused = false
	$MarginContainer/UIControl/StoreMarginContainer.visible = true 
	$MarginContainer/Store.visible = false

func toggle_game_mode(is_game: bool):
	# Display only information during Game
	$MarginContainer/PauseControl.visible = is_game
	$MarginContainer/UIControl.visible = not is_game
	$MarginContainer/Items.toggle_game_mode(is_game)

func toggle_countdown(is_activated: bool):
	$Countdown.activated = is_activated

func _on_pause_texture_button_pressed():
	Session.click()
	$MarginContainer/PauseControl.visible = false
	$PauseDivider.visible = true
	emit_signal("pause_game")

func _on_continue_button_pressed():
	Session.click()
	$MarginContainer/PauseControl.visible = true
	$PauseDivider.visible = false
	emit_signal("continue_game")
	
func submit_shield(smash_left: int):
	$MarginContainer/Items.show_shield_contol(smash_left)

func _on_items_shield_submitted(use_shield):
	emit_signal("shield_submitted", use_shield)
	
func update_countdown(value: int):
	$Countdown.countdown = value

func update_stars(value: int):
	$Stars.number_of_visible = value

# ===== ===== =====
# For debug only, used to generate screenshot
# ===== ===== =====
func set_immediate_update_stars():
	# Prevent animation when stars enter
	$Stars.animation_duration = 0
	$Stars.interval_duration = 0
	$Stars.initial_interval_duration = 0
	
func display_immediate_bonus_text(text: String, is_down: bool, delta: Vector2):
	var bonus_text = BonusText.instantiate()
	bonus_text.text = text
	# Assign base position
	if is_down:
		bonus_text.position = display_bonus_text_position_down
	else:
		bonus_text.position = display_bonus_text_position_up
	# Randomise position
	bonus_text.position += delta
	add_child(bonus_text)
	bonus_text.keep_on_screen()
