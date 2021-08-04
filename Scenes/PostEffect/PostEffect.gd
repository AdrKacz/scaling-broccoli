extends Node


func play_shockwave(force=Constants.shockwave_force, thickness=Constants.shockwave_thickness):
	SoundManager.play_shockwave()
	$Texture.play_animation(force, thickness)
