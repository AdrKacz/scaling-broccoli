extends Node2D

export (PackedScene) var ComboScene

var score = 0
var combo = 0
var timer = 30
# Number of active games
var current_index_game = 1

func _ready():
	current_index_game = randi() % 2 # NOTE Not fixed
	
	$ComboTimer.wait_time = Constants.max_combo_time # NOTE Can be infinite
	setup_game()

func score():
	score += max(1, combo)
	$TimeTrial.add_time(1)
	$PostEffect.play_shockwave()
	add_combo()

func miss():
#	$TimeTrial.remove_time(1) # NOTE To parametize
#	TODO : Animation to see
	$ComboTimer.stop()
	combo = 0

func wrong():
	$TimeTrial.remove_time(2)
	miss()
	

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
#		Add Combo Timer # NOTE To parametize
		$ComboTimer.stop()
		$ComboTimer.start()
	# Change mode
	if combo >= 1:
#		combo = 0
		change_mode()

func change_mode():
	for child in $Games.get_children():
		child.stop_game()
		child.visible = false
	setup_game()
	

func _on_ComboTimer_timeout():
	miss()
	
func setup_game():
#	var index_game = randi() % $Games.get_child_count()
	var index_game  = 1 - current_index_game # NOTE Not fixed
	
	var game_child = $Games.get_child(index_game)
	game_child.visible = true
	game_child.start_game(Constants.GameTime.get(game_child.name, Constants.default_wait_time))
	current_index_game = index_game

func _on_TimeTrial_lost():
	Session.lose()
