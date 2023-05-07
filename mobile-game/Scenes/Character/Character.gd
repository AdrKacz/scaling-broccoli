extends Node2D

var state: int = 0:
	get:
		return state
	set(value):
		$Sprite2D.modulate = Constants.State[value]
		state = value

func shake():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("Shake")
	
func pulse():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("pulse")
