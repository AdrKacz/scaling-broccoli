extends Node2D

export (PackedScene) var ComboScene

signal score
signal miss
signal wrong
signal no_combo_time_left

#var wait_twice = false

#func _ready():
#	# Starts randomly not to be at the same time than other games
#	yield(get_tree().create_timer((randi() % int(100 * wait_time) / 100)), "timeout")
#	$ChangeState.wait_time = wait_time
#
#	$ChangeState.start()
#	$Background.change_state(0)
#	$Character.set_state(1)

func setup():
	$Character.set_state_to(StateManager.get_character_next_state($Background.state, $Character.state))
	update_background_state()
	
	
func update_combo_time(new_value, delta):
	$ComboTimer.update_time(new_value, delta)

# Every time the player clicks
func _on_Character_click(state):
	# He scored
	if $Character.state == $Background.state:
		emit_signal("score")
		# Update background and character
		$Character.set_state_to(StateManager.get_character_next_state($Background.state, $Character.state))
		update_background_state()

	# He lost
	else:
		emit_signal("wrong")
		$Character.shake()
#		wait_twice = false

func update_background_state():
	var new_background_state = StateManager.get_background_next_state($Background.state, $Character.state)
	$Background.change_state(new_background_state)
	
func update_background_state_to(state):
	var new_background_state = StateManager.get_background_next_state($Background.state, $Character.state)
	$Background.change_state(state)
	
func update_character_state_to(state):
	$Character.set_state_to(state)


#func change_state(swap=0):
#	# Every background change we check if we miss
#	if $Background.state == $Character.state:
#		if wait_twice:
#			wait_twice = false
#			emit_signal("miss")
#		else:
#			wait_twice = true
#			return
#	# Update background
#	var new_background_state = StateManager.get_background_next_state($Background.state, $Character.state)
#	$Background.change_state(new_background_state)


func _on_ComboTimer_no_time_left():
	print("...Emit End Signal")
	emit_signal("no_combo_time_left")
