extends Node

func score(): 
	increment_combos_strike()
	Constants.score += Constants.score_factor * Constants.lives * Constants.combos_strike
	$GameUI.update_score(Constants.score)
	# juicy animation
	if randf() <= 0.3:
		# Note: (old) was changing mode here one every three success (from 1 tile to 4 tiles)
		$PostEffect.play_shockwave(Constants.shockwave_force_strong, Constants.shockwave_thickness_strong)
	else:
		$PostEffect.play_shockwave()
	
		
func increment_combos_strike():
	Constants.combos_strike += 1
	if Constants.combos_strike % Constants.combos_reward_strike == 0:
		earn_life()
	
	if Constants.combos_strike >= 2:
		$GameUI.display_bonus_text('x' + str(Constants.combos_strike))
	
func reset_combos_strike():
	Constants.combos_strike = 0

func earn_life():
	if Constants.lives < Constants.max_lives:
		Constants.lives += 1

func lose_life():
	Constants.lives -= 1
	if Constants.lives == 0:
		$GameUI.visible = false
		# TODO: lose is a bit straighforward, a little animation won't hurt
		Session.lose()

func wrong():
	reset_combos_strike()
	lose_life()

func _on_game_miss():
	reset_combos_strike()
