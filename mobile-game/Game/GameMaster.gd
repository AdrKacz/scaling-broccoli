extends Node

var has_lost: bool = false
func _ready():
	has_lost = false

func score(): 
	increment_combos_strike()
	Constants.score += Constants.score_factor * Constants.combos_strike
	$GameUI.update_score(Constants.score)
	
		
func increment_combos_strike():
	Constants.combos_strike += 1
	
	if Constants.combos_strike >= 2:
		$SpeedLines.level = int(Constants.combos_strike / 10)
		$GameUI.display_bonus_text('x' + str(Constants.combos_strike))
	
func reset_combos_strike():
	$SpeedLines.level = -1
	Constants.combos_strike = 0

func lose():
	if has_lost:
		return
	has_lost = true
	var tween: Tween = create_tween().bind_node(self)
	tween.tween_callback($GameUI.set_visible.bind(false))
	tween.tween_callback($Explosion.explode)
	tween.tween_callback(Session.lose_menu).set_delay($Explosion.animation_duration)

func wrong():
	reset_combos_strike()
	lose()

func _on_game_miss():
	reset_combos_strike()
