extends Node

@export var BonusText: PackedScene
@export var CountDown: PackedScene

var display_bonus_text_position: Vector2

func _ready():
	$Game/Game.setup()
	var area_size: Vector2 = $PauseControl/MarginContainer.get_parent_area_size()
	display_bonus_text_position = Vector2(
		area_size.x * .5,
		area_size.y * .8
	)

func score():
	if randf() <= 0.3:
		# Note: (old) was changing mode here one every three success (from 1 tile to 4 tiles)
		$PostEffect.play_shockwave(Constants.shockwave_force_strong, Constants.shockwave_thickness_strong)
	else:
		$PostEffect.play_shockwave()
	increment_combos_strike()
		
func increment_combos_strike():
	Constants.combos_strike += 1
	if Constants.combos_strike % Constants.combos_reward_strike == 0:
		earn_life()
	
	if Constants.combos_strike >= 2:
		display_bonus_text('x' + str(Constants.combos_strike))
	
func reset_combos_strike():
	Constants.combos_strike = 0

func earn_life():
	if Constants.lives < Constants.max_lives:
		Constants.lives += 1

func lose_life():
	Constants.lives -= 1
	if Constants.lives == 0:
		# TODO: lose is a bit straighforward, a little animation won't hurt
		Session.lose()

func wrong():
	reset_combos_strike()
	lose_life()

func display_bonus_text(text):
	# TODO: text display on top of each other sometime, rethink the position and/or the animation
	var bonus_text = BonusText.instantiate()
	bonus_text.text = text
	bonus_text.position = display_bonus_text_position + Vector2(randf_range(-64, 64), randf_range(-64, 64)) # randomise
	add_child(bonus_text)

func _on_Pause_pressed():
	Constants.pause = true
	Session.pause_with_opacity()


func _on_game_miss():
	reset_combos_strike()
