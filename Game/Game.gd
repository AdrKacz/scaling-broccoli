extends Node2D

export (PackedScene) var ComboScene

signal score
signal miss
signal wrong

#func _ready():
#	# Starts randomly not to be at the same time than other games
#	yield(get_tree().create_timer((randi() % int(100 * wait_time) / 100)), "timeout")
#	$ChangeState.wait_time = wait_time
#
#	$ChangeState.start()
#	$Background.change_state(0)
#	$Character.set_state(1)
	
func start_game(wait_time):
	$ChangeState.wait_time = wait_time

	$ChangeState.start()
	$Background.change_state(0)
	$Character.set_state(1)
	
func stop_game():
	$ChangeState.stop()
	
func update_combo_time(new_value, delta):
	$ComboTimer.update_time(new_value, delta)

# Every time the player clicks
func _on_Character_click(state):
	# He scored
	if $Character.state == $Background.state:
		emit_signal("score")

		# Reset timer
		$ChangeState.stop()

		# Update background and character
		var new_background_state = Constants.new_state([$Background.state])
		$Background.change_state(new_background_state)
		$Character.set_state(new_background_state)

		$ChangeState.start()

	# He lost
	else:
		emit_signal("wrong")
		$Character.wrong_color()


func _on_ChangeState_timeout():
	# Every background change we check if we miss
	if $Background.state == $Character.state:
		emit_signal("miss")
	# Update background
	var new_background_state = Constants.new_state([$Background.state])
	$Background.change_state(new_background_state)
