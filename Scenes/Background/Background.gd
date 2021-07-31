extends Node2D
signal change

var state = 0




func _on_ChangeTimer_timeout():
	# Send old state
	emit_signal("change", state)
	state = Constants.new_state([state])
	$State.text = str(state)
