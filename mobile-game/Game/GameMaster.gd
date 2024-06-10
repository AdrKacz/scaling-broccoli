extends CanvasLayer

signal on_screen

var level_final_number_of_crack_circles: int
var level_final_number_of_crack_lines: int
var combo_required_for_current_card: int
var wait_for_shield_submit: bool = false

const CARDS_FOLDER: String = "res://assets/Cards"
@onready var tutorial_cards: Array[String] = Constants.dir_contents(CARDS_FOLDER, 'Tutorial')

func _ready():
	Constants.combos_strike = 0
	Constants.local_combos_strike = 0
	$Control/Game.reset_crack()
	init_level()
	emit_signal("on_screen")
	$Control/Game.paused = true
	
func increment_combos_strike():
	var increment: int = int(pow(2, Memory.active_hammers))
	Constants.combos_strike += increment
	Constants.local_combos_strike += increment
	
	if Constants.combos_strike >= 2:
		@warning_ignore("integer_division")
		$Control/SpeedLines.level = int(Constants.combos_strike / 10)
		$Control/GameUI.display_bonus_text('x' + str(Constants.combos_strike))

var tween: Tween
func unlock_card():
	if not Memory.active_card:
		print('No active card. This should never happen.')
		return
	if tween:
		tween.kill()
	Session.active_shields = min(3, Memory.shields)
	Memory.unlock_active_card() # side-effect: reset active card
	$Control/Game.paused = true
	$Control/Game.emit_neutral_hit = true # Wait for signal to move on to next card
	$Control/Game.character_visible = false
	# TODO: Add flash and screen shake
	$Control/Game.show_background_image() # remove glass
	tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Control/Game, "background_abberation", 0.1, 0.3).set_ease(Tween.EASE_IN)
	# tween.parallel().tween_property($Control/Game, "background_zoom", 0.9, 0.3).set_ease(Tween.EASE_IN)
	tween.tween_property($Control/Game, "background_abberation", 0, 0.3).set_ease(Tween.EASE_OUT)
	# tween.parallel().tween_property($Control/Game, "background_zoom", 1, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_callback($Control/SpeedLines.set_level.bind(-1))

func reset_combos_strike():
	$Control/SpeedLines.level = -1
	Constants.combos_strike = 0
	Constants.local_combos_strike = 0
	
func fail():
	reset_combos_strike()
	$Control/Game.reset_crack()
	Memory.active_hammers = 0
	Session.active_shields = min(3, Memory.shields)

func _on_game_miss_or_wrong(is_wrong: bool):
	if Session.active_shields > 0:
		# Offer the player the possiblity to use a shield to continue
		$Control/Game.paused = true
		wait_for_shield_submit = true
		$Control/GameUI.submit_shield(is_wrong) # is_wrong means that there was a tap
	else:
		fail()

func _on_game_score() -> void:
	$Control/GameUI.remove_introduction_text()
	increment_combos_strike()
	
	if Constants.local_combos_strike >= combo_required_for_current_card:
		Constants.local_combos_strike = 0
		unlock_card()
	else:
		var circle_step: float = float(combo_required_for_current_card - 1) / float(level_final_number_of_crack_circles)
		var line_step: float = float(combo_required_for_current_card - 1) / float(level_final_number_of_crack_lines)
		# circle_step and line_step will never be null`
		# if combo_required_for_current_card is 1, then it's catched in first condition
		# as local_combos_strike will always be equal or greater than 1 after you score
		var new_number_of_circle: int = int(Constants.local_combos_strike / circle_step)
		var new_number_of_line: int = int(Constants.local_combos_strike / line_step)
		$Control/Game.update_crack(new_number_of_circle, new_number_of_line)

func _get_random_card() -> String:
	# TODO: Don't return a card too hard if the player if not good enough
	var all_cards: Array[String] = Constants.dir_contents(CARDS_FOLDER)
	var unlocked_cards: Array[String] = Memory.get_unlocked_cards()
	var locked_cards: Array[String] = []
	for card in all_cards:
		if not card in unlocked_cards:
			locked_cards.append(card)
	if locked_cards.size() > 0:
		return locked_cards.pick_random()
	else:  
		# TODO: handle when no more cards
		print('All cards unlocked, redo a random one.')
		return all_cards.pick_random()

func _get_next_tutorial_card():
	var unlocked_cards: Array[String] = Memory.get_unlocked_cards()
	for tutorial_card in tutorial_cards:
		if not tutorial_card in unlocked_cards:
			return tutorial_card

func init_level() -> void:
	$Control/Game.paused = false
	$Control/Game.character_visible = true
	$Control/Game.hide_background_image() # add glass
	$Control/Game.background_abberation = 0
	# Images
	if not Memory.active_card:
		var next_tutorial_card = _get_next_tutorial_card()
		if next_tutorial_card:  # Tutorial not finished yet
			Memory.active_card = next_tutorial_card
		else:
			Memory.active_card = _get_random_card()
	combo_required_for_current_card = int(Memory.active_card.get_slice('_', 0))
	$Control/Game.update_background_image(CARDS_FOLDER + "/" + Memory.active_card)
	# Cracks
	level_final_number_of_crack_circles = min(combo_required_for_current_card, randi_range(4, 6))
	level_final_number_of_crack_lines = min(combo_required_for_current_card * 2, randi_range(15, 20))
	$Control/Game.generate_crack(level_final_number_of_crack_circles)

func _on_game_neutral_hit():
	if not $Control/Game.paused:
		return # Game should only emit this signal when paused
	$Control/Game.emit_neutral_hit = false
	if tween:
		# set parameters to what they should be after the tween (from unlock_stage)
		tween.kill()
		$Control/Game.background_abberation = 0
	if Constants.combos_strike >= 2:
		@warning_ignore("integer_division")
		$Control/SpeedLines.level = int(Constants.combos_strike / 10)
	$Control/Game.reset_crack()
	init_level()


func _on_game_paused_changed():
	$Control/GameUI.toggle_game_mode(not $Control/Game.paused)

func _on_game_ui_continue_game():
	$Control/Game.paused = false

func _on_game_ui_pause_game():
	$Control/Game.paused = true

func _on_game_ui_shield_submitted(use_shield):
	if not wait_for_shield_submit:
		return # GameUI should never emit this signal if not asked to
	if use_shield:
		Session.active_shields -= 1
		Memory.shields -= 1
	else:
		fail()
