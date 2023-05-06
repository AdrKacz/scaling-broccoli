extends Node

func score(): 
	increment_combos_strike()
	Constants.score += Constants.score_factor * Constants.lives * Constants.combos_strike
	$GameUI.update_score(Constants.score)
	
		
func increment_combos_strike():
	Constants.combos_strike += 1
	
	if Constants.combos_strike >= 2:
		$SpeedLines.level = int(Constants.combos_strike / 10)
		$GameUI.display_bonus_text('x' + str(Constants.combos_strike))
	
func reset_combos_strike():
	$SpeedLines.level = -1
	Constants.combos_strike = 0

func lose_life():
	$GameUI.lose_heart()
	Constants.lives -= 1
	if Constants.lives == 0:
		$GameUI.visible = false
		Session.lose_menu()

func wrong():
	reset_combos_strike()
	lose_life()

func _on_game_miss():
	reset_combos_strike()
