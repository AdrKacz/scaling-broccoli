extends ColorRect

func _ready():
	material.set_shader_parameter("thickness", randf_range(0.05, 0.2));
	$AnimationPlayer.play("wave")
