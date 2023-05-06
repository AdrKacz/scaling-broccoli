extends Node2D
signal tap

var state: int = 0:
	get:
		return state
	set(value):
		$Sprite2D.modulate = Constants.State[value]
		state = value
		
func _on_control_gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed() :
		handle_tap()

func handle_tap():
	Session.tap()
	emit_signal("tap")

func shake():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("Shake")
	
func pulse():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("pulse")
