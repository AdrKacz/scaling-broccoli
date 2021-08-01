extends Node2D

export (PackedScene) var ComboScene
export var wait_time = Constants.background_wait_time

signal score
signal miss
signal wrong

func _ready():
	# Starts randomly not to be at the same time than other games
	yield(get_tree().create_timer((randi() % int(100 * wait_time) / 100)), "timeout")
	$ChangeState.wait_time = wait_time

	$ChangeState.start()
	$Background.change_state(0)
	$Character.set_state(1)

# Every time the player clicks
func _on_Character_click(state):
	# He scored
	emit_signal("score")
	if $Character.state == $Background.state:
#		emit_signal("score")

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

	# Reset character's state that isn't the background value
	print("Click on state ", state)


func _on_ChangeState_timeout():
	# Every background change we check if we miss
	if $Background.state == $Character.state:
		emit_signal("miss")
	# Update background
	var new_background_state = Constants.new_state([$Background.state])
	$Background.change_state(new_background_state)
