extends CanvasLayer

signal on_screen

@export var is_challenge: bool = false
@export var challenge: Dictionary

func _ready():
	Constants.combos_strike = 0
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

var tween: Tween
func update_crack(to: float, duration: float, transition_type: Tween.TransitionType, ease_type: Tween.EaseType):
	if tween:
		tween.kill()
	tween = create_tween().bind_node(self).set_trans(transition_type).set_ease(ease_type)
	tween.tween_property($Control/Game, "cracks", to, duration)

func _on_game_miss_or_wrong():
	reset_combos_strike()
	Constants.local_combos_strike = 0
	update_crack(0., .5, Tween.TRANS_QUAD, Tween.EASE_IN)

func _on_game_score() -> void:
	$Control/GameUI.remove_introduction_text()
	increment_combos_strike()
	
	if Constants.local_combos_strike >= Constants.local_combo_for_next_stage:
		Constants.local_combos_strike = 0
		$Control/GameUI.increase_stage()
	var proportion_completed: float = float(Constants.local_combos_strike) / float(Constants.local_combo_for_next_stage)
	update_crack(min(1., proportion_completed), .5, Tween.TRANS_BACK, Tween.EASE_OUT)
