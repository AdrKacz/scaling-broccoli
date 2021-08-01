extends Node2D

export (PackedScene) var ComboScene

var score = 0
var combo = 0
var swap = 0
var count_combo = true
# Number of active games
var time_left = 0
var current_index_game = 1
var last_change_combo = 0
var game_child = ""

func _ready():
	current_index_game = randi() % 2 # NOTE Not fixed
	setup_game()

func score():
	score += max(1, combo)
	$TimeTrial.add_time(Constants.get_bonus_time() * combo)
	add_combo()

func miss():
#	$TimeTrial.remove_time(1) # NOTE To parametize
#	TODO : Animation to see
#	reset_combo()
	pass

func wrong():
	$TimeTrial.remove_time(Constants.get_malus_time())
#	reset_combo()
	
func reset_combo():
	combo = 0
	last_change_combo = 0
	$Games.get_child(current_index_game).update_combo_time(0, $ComboTimerUI.wait_time)
	swap = 0
	count_combo = false
	time_left = Constants.get_max_combo_time() * $ComboTimerUI.wait_time
	

func add_combo():
	combo += 1
	# Display combo
	if combo >= 2:
		var comb = ComboScene.instance()
		comb.multiplier = combo
		var x = $CornersCombo/UpperLeft.position.x + randi() % int($CornersCombo/LowerRight.position.x - $CornersCombo/UpperLeft.position.x)
		var y = $CornersCombo/UpperLeft.position.y + randi() % int($CornersCombo/LowerRight.position.y - $CornersCombo/UpperLeft.position.y)
		comb.position = Vector2(x, y)
		add_child(comb)
	# Change mode
	if combo - last_change_combo >= 2:
#		combo = 0
		last_change_combo = combo
		change_mode()
		$PostEffect.play_shockwave(Constants.shockwave_force_strong, Constants.shockwave_thickness_strong)
	else:
		$PostEffect.play_shockwave()
		
	# Relaunch another combo
	swap = 0
	count_combo = true
	time_left = Constants.get_max_combo_time()

func change_mode():
	for child in $Games.get_children():
		child.visible = false
	setup_game()
	
func setup_game():
#	var index_game = randi() % $Games.get_child_count()
	var index_game  = 1 - current_index_game # NOTE Not fixed
	
	game_child = $Games.get_child(index_game)
	game_child.setup()
	game_child.visible = true
	$ChangeState.wait_time = Constants.get_refresh_time(game_child.name)
	$ChangeState.start()
	current_index_game = index_game
	# Augment difficulty
	Constants.hardness += 0.2

func stop_game():
	$ChangeState.stop()
	
func _on_TimeTrial_lost():
	Session.lose($Menus, score)

func _on_ComboTimerUI_timeout():
	time_left -= $ComboTimerUI.wait_time
	if time_left > 0:
		$Games.get_child(current_index_game).update_combo_time(time_left, $ComboTimerUI.wait_time)


func _on_Pause_pressed():
	Session.pause_with_opacity()

func _on_ChangeState_timeout():
	# Tell games to update
	$Games.get_child(current_index_game).change_state(swap)
	# Update combo swaps
	if count_combo:
		swap += 1
		if swap > Constants.max_combo_swaps:
			reset_combo()
