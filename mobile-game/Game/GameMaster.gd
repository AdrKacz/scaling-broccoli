extends CanvasLayer

signal on_screen

var level_final_number_of_crack_circles: int
var level_final_number_of_crack_lines: int
var current_card: String
var combo_required_for_current_card: int

const CARDS_FOLDER: String = "res://assets/Cards"
const TUTORIAL_CARDS: Array[String] = [
	"2_Tutorial1.jpeg",
	"4_Tutorial2.jpeg",
	"6_Tutorial3.jpeg",
	"8_Tutorial4.jpeg",
	"10_Tutorial5.jpeg"
]

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
	if not current_card:
		print('No active card. This should never happen.')
		return
	if tween:
		tween.kill()
	Memory.unlock_card(current_card)
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

func _on_game_miss_or_wrong():
	reset_combos_strike()
	$Control/Game.reset_crack()
	Memory.active_hammers = 0

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

func init_level() -> void:
	$Control/Game.paused = false
	$Control/Game.character_visible = true
	$Control/Game.hide_background_image() # add glass
	$Control/Game.background_abberation = 0
	# Images
	var unlocked_cards: Array[String] = Memory.get_unlocked_cards()
	if unlocked_cards.size() < TUTORIAL_CARDS.size(): # Tutorial not finished yet
		current_card = TUTORIAL_CARDS[unlocked_cards.size()]
	else:
		pass
	combo_required_for_current_card = int(current_card.get_slice('_', 0))
	$Control/Game.update_background_image(CARDS_FOLDER + "/" + current_card)
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
