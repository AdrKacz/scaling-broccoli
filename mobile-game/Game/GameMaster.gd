extends CanvasLayer

signal on_screen

@export var is_challenge: bool = false
@export var challenge: Dictionary

func _ready():
	Constants.combos_strike = 0
	
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

func _on_game_score() -> void:
	$Control/GameUI.remove_introduction_text()
	increment_combos_strike()
	if Constants.local_combos_strike >= Constants.local_combo_for_next_stage:
		Constants.local_combos_strike = 0
		$Control/GameUI.increase_stage()
