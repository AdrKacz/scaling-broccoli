extends Node2D
signal change

var state = 0


func reset():
	$ChangeTimer.stop()
	$ChangeTimer.start()
	change_state(Constants.new_state([state]))
	

func _on_ChangeTimer_timeout():
	# Send old state
	emit_signal("change", state)
	change_state(Constants.new_state([state]))
	
func change_state(new_state):
	$State.text = str(state)
	$Sprite.modulate = Constants.State[state]
	state = new_state
