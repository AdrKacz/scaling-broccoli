extends Node2D

export (PackedScene) var ComboScene

var score = 0
var combo = 0
var timer = 30
# Number of active games
var current_index_game = 1
var last_change_combo = 0

func _ready():
	$ComboTimer.wait_time = Constants.max_combo_time
	current_index_game = randi() % 2 # NOTE Not fixed
	setup_game()

func score():
	score += max(1, combo)
	$TimeTrial.add_time(1)
	add_combo()

func miss():
#	$TimeTrial.remove_time(1) # NOTE To parametize
#	TODO : Animation to see
#	reset_combo()
	pass

func wrong():
	$TimeTrial.remove_time(2)
#	reset_combo()
	
func reset_combo():
	combo = 0
	last_change_combo = 0
	$Games.get_child(current_index_game).update_combo_time(0, $ComboTimerUI.wait_time)
	$ComboTimer.stop()
	

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
		
#	Add Combo Timer # NOTE To parametize
	$ComboTimer.stop()
	$ComboTimer.start()

func change_mode():
	for child in $Games.get_children():
		child.stop_game()
		child.visible = false
	setup_game()
	
func setup_game():
#	var index_game = randi() % $Games.get_child_count()
	var index_game  = 1 - current_index_game # NOTE Not fixed
	
	var game_child = $Games.get_child(index_game)
	game_child.visible = true
	game_child.start_game(Constants.GameTime.get(game_child.name, Constants.default_wait_time))
	current_index_game = index_game

func _on_TimeTrial_lost():
	Session.lose($Menus, score)


func _on_ComboTimer_timeout():
	reset_combo()

func _on_ComboTimerUI_timeout():
	if $ComboTimer.time_left > 0:
		$Games.get_child(current_index_game).update_combo_time($ComboTimer.time_left, $ComboTimerUI.wait_time)


func _on_Pause_pressed():
	Session.pause_with_opacity()
