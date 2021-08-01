extends Sprite


func play_animation(force, thickness):
	material.set_shader_param("force", force);
	material.set_shader_param("thickness", thickness);
	$AnimationPlayer.play("wave")
