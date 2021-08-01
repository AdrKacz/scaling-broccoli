extends Node


func play_shockwave(force=Constants.shockwave_force, thickness=Constants.shockwave_thickness):
	$SwoushSound.play()
	$Texture.play_animation(force, thickness)
