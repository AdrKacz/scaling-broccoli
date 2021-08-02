extends Node2D

export (PackedScene) var ComboScene

var combo_time_left = 0

var last_change_mode_combo = 0


# TODO : Signal continue emiting when no game mode activated (...)


func _ready():
	Constants.game_mode = 1 # randi() % 2 # NOTE Not fixed
	setup_game()

func score():
	var level_before = Constants.level
	Constants.score += (Constants.level + 1) * (Constants.combo + 1)
	var level_after = Constants.level
	$TimeTrial.add_time(Constants.time_bonus_to_next)
	add_combo()
	if level_before < level_after:
		$TimeTrial.add_time(Constants.maximum_time)
		display("Level" + str(level_after))

func miss():
	# Pourrait descendre d'un niveau
	pass

func wrong():
	$TimeTrial.remove_time(Constants.time_malus)
	combo_time_left = 0
	$Games.get_child(Constants.game_mode).update_combo_time(0, $ComboTimerUI.wait_time)
	
func reset_combo():
	if Constants.combo >= 2:
		$NoComboSound.play()
	print("Reset Combo Level")
	Constants.combo = 0
	last_change_mode_combo = 0
	update_swap_time()

func display(text):
	var combo_text = ComboScene.instance()
	combo_text.text = text
	var x = $CornersCombo/UpperLeft.position.x + randi() % int($CornersCombo/LowerRight.position.x - $CornersCombo/UpperLeft.position.x)
	var y = $CornersCombo/UpperLeft.position.y + randi() % int($CornersCombo/LowerRight.position.y - $CornersCombo/UpperLeft.position.y)
	combo_text.position = Vector2(x, y)
	add_child(combo_text)

func add_combo():
	Constants.combo += 1
	# Display combo text
	if Constants.combo >= 2:
		display("X" + str(Constants.combo))
	# Change mode if needed and play according shockwave
#	if Constants.combo - last_change_mode_combo_level >= 2:
##		combo = 0
#		last_change_mode_combo_level = Constants.combo_level
#		change_mode()
#		$PostEffect.play_shockwave(Constants.shockwave_force_strong, Constants.shockwave_thickness_strong)
#	else:
	$PostEffect.play_shockwave()
		
	combo_time_left = Constants.combo_time
#	Update swap time (at the end because can depends on mode)
	update_swap_time()

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
#	var index_game = randi() % $Games.get_child_count()
	Constants.game_mode  = 1 - Constants.game_mode # NOTE Not fixed
	
	var game_child = $Games.get_child(Constants.game_mode)
	game_child.setup()
	game_child.visible = true
	$ChangeState.wait_time = Constants.swap_time
	$ChangeState.start()
	# Augment difficulty
#	Constants.hardness += 0.2

func stop_game():
	$ChangeState.stop()
	
func _on_TimeTrial_lost():
#	Stop Timer
	$ChangeState.stop()
#	Display End screen
	Session.lose()

func _on_ComboTimerUI_timeout():
	combo_time_left -= $ComboTimerUI.wait_time
	if combo_time_left > 0:
		$Games.get_child(Constants.game_mode).update_combo_time(combo_time_left, $ComboTimerUI.wait_time)
	else:
		$Games.get_child(Constants.game_mode).update_combo_time(0, $ComboTimerUI.wait_time)


func _on_Pause_pressed():
	Session.pause_with_opacity()

func _on_ChangeState_timeout():
	$ChangeStateSound.play()
	Constants.swap_left_before_combo_ends -= 1
	$Games.get_child(Constants.game_mode).update_background_state()
	update_swap_time()


func _on_Game_no_combo_time_left():
	reset_combo()
