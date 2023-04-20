extends Node2D
signal click

var state = 0


func set_state_to(new_state):
#	change_state(Constants.new_state([state] if Constants.can_be_background_state else Constants.new_state([state, background_state])))
	change_state(new_state)


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		handle_action()
		
func _input(event):
	if is_visible_in_tree() and event is InputEventKey and event.keycode == KEY_SPACE and event.is_pressed() and not event.is_echo():
		handle_action()
		
func handle_action():
	SoundManager.play_action()
	emit_signal("click", state)

		
func change_state(new_state):
	$Sprite2D.modulate = Constants.State[new_state]
	state = new_state

func shake():
	$AnimationPlayer.play("Shake")
