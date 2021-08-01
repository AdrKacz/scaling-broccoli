extends Node2D

export (PackedScene) var ComboScene

var score = 0
var combo = 0
var timer = 30
# Number of active games
var mode = 6
var modes = [1, 2, 4]

func _ready():
	$ComboTimer.wait_time = Constants.max_combo_time # NOTE Can be infinite
	setup_game()

func score():
	score += Constants.ModeScore[mode] * max(1, combo)
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
	if combo >= 3:
#		combo = 0
		change_mode()

func change_mode():
	pass
	

func _on_ComboTimer_timeout():
	miss()
	
func setup_game():
	var index_game = randi() % $Games.get_child_count()
	var game_child = $Games.get_child(index_game)
	print(game_child.name)
	print(Constants.GameTime.get(game_child.name, Constants.default_wait_time))
	game_child.visible = true
	game_child.start_game(Constants.GameTime.get(game_child.name, Constants.default_wait_time))

func _on_TimeTrial_lost():
	Session.lose()
