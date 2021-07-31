extends Node2D
signal click

var state = 0


func set_state(backgroud_state):
	change_state(Constants.new_state([state] if Constants.can_be_background_state else [state, backgroud_state]))


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("click", state)
func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_SPACE:
		emit_signal("click", state)
		
		
func change_state(new_state):
	$State.text = str(state)
	$Sprite.modulate = Constants.State[state]
	state = new_state
