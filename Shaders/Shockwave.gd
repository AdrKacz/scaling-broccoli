extends Sprite2D


func play_animation(force, thickness):
	material.set_shader_parameter("force", force);
	material.set_shader_parameter("thickness", thickness);
	$AnimationPlayer.play("wave")
