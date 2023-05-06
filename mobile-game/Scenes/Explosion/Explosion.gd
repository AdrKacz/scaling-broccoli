extends ColorRect

var animation_duration: float
func _ready():
	visible = false
	material.set_shader_parameter("time", 0.)
	animation_duration = material.get_shader_parameter("animation_duration")
	
func update_explosion_time(time: float):
	material.set_shader_parameter("time", time)
	
var tween: Tween
func explode():
	if tween:
		tween.kill()
	visible = true
	tween = create_tween().bind_node(self)
	tween.tween_method(update_explosion_time, 0., 1., animation_duration)
