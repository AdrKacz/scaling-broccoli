extends Node2D
signal tap

var state: int = 0:
	get:
		return state
	set(value):
		$Sprite2D.modulate = Constants.State[value]
		state = value

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		handle_tap()

func handle_tap():
	SoundManager.play_action()
	emit_signal("tap")

func shake():
	$AnimationPlayer.play("Shake")
