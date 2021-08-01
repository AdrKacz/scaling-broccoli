extends Node


func play_shockwave(force=Constants.shockwave_force, thickness=Constants.shockwave_thickness):
	$Texture.play_animation(force, thickness)
