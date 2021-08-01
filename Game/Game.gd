extends Node2D
export (PackedScene) var ComboScene
export var wait_time = Constants.background_wait_time

var combo = 0
var score = 0

func _ready():
	# Starts randomly not to be at the same time than other games
	yield(get_tree().create_timer((randi() % int(100 * wait_time) / 100)), "timeout")
	$ChangeState.wait_time = wait_time
	$ComboTimer.wait_time = Constants.max_combo_time # NOTE Can be infinite

	$ChangeState.start()
	$Background.change_state(0)
	$Character.set_state(1)

# Every time the player clicks we check
func _on_Character_click(state):
	# He won
	if $Character.state == $Background.state:
		score += 1 * max(1, combo)
		print("SCORE : ", score)
#		$TimeTrial.add_time(1 * combo) # NOTE To parametize
		add_combo()

		$ChangeState.stop()

		var new_background_state = Constants.new_state([$Background.state])
		$Background.change_state(new_background_state)
		$Character.set_state(new_background_state)

		$ChangeState.start()

	# He lost
	else:
		$Character.wrong_color()
		reset_combo()
		add_combo()

	# Reset character's state that isn't the background value
	print("Click on state ", state)


# Every background change we check if we miss
func _on_ChangeState_timeout():
	if $Background.state == $Character.state:
		print("... Miss background ")
#		reset_combo() # NOTE To parametize
	var new_background_state = Constants.new_state([$Background.state])
	$Background.change_state(new_background_state)

func reset_combo():
#	$TimeTrial.remove_time(1) # NOTE To parametize
#	TODO : Animation to see
	$ComboTimer.stop()
	combo = 0

func add_combo():
	combo += 1
	if combo >= 2:
		var comb = ComboScene.instance()
		comb.multiplier = combo
		print()
		var x = $CornersCombo/UpperLeft.position.x + randi() % int($CornersCombo/LowerRight.position.x - $CornersCombo/UpperLeft.position.x)
		var y = $CornersCombo/UpperLeft.position.y + randi() % int($CornersCombo/LowerRight.position.y - $CornersCombo/UpperLeft.position.y)
		comb.position = Vector2(x, y)
		add_child(comb)
#		Add Combo Timer # NOTE To parametize
		$ComboTimer.stop()
		$ComboTimer.start()


func _on_ComboTimer_timeout():
	reset_combo()
