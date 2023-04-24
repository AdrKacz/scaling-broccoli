extends Node2D
signal click

var state: int = 0:
	get:
		return state
	set(value):
		$Sprite2D.modulate = Constants.State[value]
		state = value

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		print('Detect Click')
		handle_action()

func handle_action():
	SoundManager.play_action()
	emit_signal("click", state)

func shake():
	$AnimationPlayer.play("Shake")
