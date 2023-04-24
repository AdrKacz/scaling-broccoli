extends Node

@export var BonusText: PackedScene
@export var CountDown: PackedScene

var combo_time_left = 0
var success_counter = 0

var last_change_mode_combo = 0

func _ready():
	_on_GameIntro_score()
# TODO : Signal continue emiting when no game mode activated (...)

func score():
	print('You scored!')
	success_counter += 1
	if success_counter % 3 == 0:
		$PostEffect.play_shockwave(Constants.shockwave_force_strong, Constants.shockwave_thickness_strong)
		change_mode()
	else:
		$PostEffect.play_shockwave()
		
	var level_before = Constants.level
	Constants.score += (Constants.level + 1) * (Constants.combo + 1)
	var level_after = Constants.level
	$TimeTrial.add_time(Constants.time_bonus_to_next)
	add_combo()
	if level_after > level_before:
		$TimeTrial.add_time(Constants.maximum_time)
		display("Up", $Positions/LevelPosition.position)

func wrong():
	print("You missed!")
	$TimeTrial.remove_time(Constants.time_malus)
	combo_time_left = 0
	$Games.get_child(Constants.game_mode).update_combo_time(0, $ComboTimerUI.wait_time)
	reset_combo()

func reset_combo():
	if Constants.combo >= 2:
		SoundManager.play_no_combo()
	Constants.combo = 0
	last_change_mode_combo = 0
	update_swap_time()

func display(text, position_base):
	var combo_text = BonusText.instantiate()
	combo_text.text = text
#	Calculate random offset (TODO)
	combo_text.position = position_base + Vector2(randf_range(-64, 64), randf_range(-64, 64)) # randomise
	add_child(combo_text)

func add_combo():
	Constants.combo += 1
	# Display combo text
	display("+" + str(Constants.combo), $Positions/ComboPosition.position)

	combo_time_left = Constants.combo_time
	update_swap_time() # Update swap time (at the end because can depends on mode)

func change_mode():
	for child in $Games.get_children():
		child.visible = false
	setup_game()

func update_swap_time():
	if ($ChangeState.wait_time != Constants.swap_time):
		$ChangeState.stop()
		$ChangeState.wait_time = Constants.swap_time
		$ChangeState.start()

func setup_game():
	var game_child = $Games.get_child(Constants.game_mode)
	game_child.setup()
	game_child.visible = true
	$ChangeState.wait_time = Constants.swap_time

func stop_game():
	$ChangeState.stop()

func _on_TimeTrial_lost():
#	Stop Timer
	$ChangeState.stop()
#	Display End screen
	Session.lose()

func _on_ComboTimerUI_timeout():
	if not Constants.pause:
		combo_time_left -= $ComboTimerUI.wait_time
		if combo_time_left > 0:
			$Games.get_child(Constants.game_mode).update_combo_time(combo_time_left, $ComboTimerUI.wait_time)
		else:
			$Games.get_child(Constants.game_mode).update_combo_time(0, $ComboTimerUI.wait_time)


func _on_Pause_pressed():
	Constants.pause = true
	Session.pause_with_opacity()

func _on_ChangeState_timeout():
	if not Constants.pause:
		SoundManager.play_change_state()
		Constants.swap_left_before_combo_ends -= 1
		$Games.get_child(Constants.game_mode).update_background_state()
		update_swap_time()


func _on_Game_no_combo_time_left():
	reset_combo()


func _on_GameIntro_score():
	$Intro/GameIntro.queue_free()
	setup_game()
	$TimeTrial.start_timer()
	$ComboTimerUI.start()
	$ChangeState.start()
	score()
