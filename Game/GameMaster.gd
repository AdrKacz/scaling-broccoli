extends Node2D

export (PackedScene) var Game
export (PackedScene) var ComboScene

var score = 0
var combo = 0
var timer = 30
# Number of active games
var mode = 6
var modes = [1, 2, 4, 6]

func _ready():
	$ComboTimer.wait_time = Constants.max_combo_time # NOTE Can be infinite
	setup_games()

func score():
	score += max(1, combo)
	$TimeTrial.add_time(1)
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
		combo = 0
		change_mode()

func change_mode():
	var new_mode = modes[randi() % modes.size()]
	while mode == new_mode:
		new_mode = modes[randi() % modes.size()]
	mode = new_mode
	get_tree().call_group("game", "queue_free")
	setup_games()
	

func _on_ComboTimer_timeout():
	miss()

func setup_games():
	var game = null
	for i in mode:
		game = Game.instance()
		add_child(game)
		game.wait_time = Constants.ModeWaitTime[mode]
		game.scale = Vector2(Constants.ModeScale[mode]["x"], Constants.ModeScale[mode]["y"])
		game.position = Vector2(Constants.ModePosition[mode][i]["x"], Constants.ModePosition[mode][i]["y"])
		game.connect("score", self, "score")
		game.connect("miss", self, "miss")
		game.connect("wrong", self, "wrong")






