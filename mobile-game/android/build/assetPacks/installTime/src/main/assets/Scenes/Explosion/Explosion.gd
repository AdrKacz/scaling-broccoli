extends ColorRect

@export var animation_duration: float = 1.0 

func _ready():
	visible = false
	material.set_shader_parameter("black_radius", 0.)

func update_explosion_radius(radius_percentage: float):
	material.set_shader_parameter("black_radius", radius_percentage)

var tween: Tween
func explode():
	if tween:
		tween.kill()
	visible = true
	tween = create_tween().bind_node(self).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT_IN)
	tween.tween_method(update_explosion_radius, 0., 1., animation_duration)
