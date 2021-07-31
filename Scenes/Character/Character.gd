extends Node2D
signal click

var state = 0


func set_state(not_this_state):
	state = Constants.new_state([state, not_this_state])
	$State.text = str(state)


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		emit_signal("click", state)
