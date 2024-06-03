extends CanvasLayer

signal on_screen

@export var is_challenge: bool = false
@export var challenge: Dictionary

var level_final_number_of_crack_circles: int
var level_final_number_of_crack_lines: int

func _ready():
	Constants.combos_strike = 0
	Constants.local_combos_strike = 0
	$Control/Game.reset_crack()
	init_level()
	emit_signal("on_screen")
	
func increment_combos_strike():
	Constants.combos_strike += 1
	Constants.local_combos_strike += 1
	
	if Constants.combos_strike >= 2:
		@warning_ignore("integer_division")
		$Control/SpeedLines.level = int(Constants.combos_strike / 10)
		$Control/GameUI.display_bonus_text('x' + str(Constants.combos_strike))
	
func reset_combos_strike():
	$Control/SpeedLines.level = -1
	Constants.combos_strike = 0

func _on_game_miss_or_wrong():
	reset_combos_strike()
	Constants.local_combos_strike = 0
	$Control/Game.reset_crack()

func _on_game_score() -> void:
	$Control/GameUI.remove_introduction_text()
	increment_combos_strike()
	
	if Constants.local_combos_strike >= Constants.local_combo_for_next_stage:
		Constants.local_combos_strike = 0
		$Control/GameUI.increase_stage()
		$Control/Game.reset_crack()
		init_level()
	else:
		var circle_step: float = float(Constants.local_combo_for_next_stage - 1) / float(level_final_number_of_crack_circles)
		var line_step: float = float(Constants.local_combo_for_next_stage - 1) / float(level_final_number_of_crack_lines)
		# circle_step and line_step will never be null`
		# if local_combo_for_next_stage is 1, then it's catched in first condition
		# as local_combos_strike will always be equal or greater than 1 after you score
		var new_number_of_circle: int = int(Constants.local_combos_strike / circle_step)
		var new_number_of_line: int = int(Constants.local_combos_strike / line_step)
		$Control/Game.update_crack(new_number_of_circle, new_number_of_line)

func init_level() -> void:
	level_final_number_of_crack_circles = min(Memory.stage, randi_range(4, 6))
	level_final_number_of_crack_lines = min(Memory.stage * 2, randi_range(15, 20))
	$Control/Game.generate_crack(level_final_number_of_crack_circles)
