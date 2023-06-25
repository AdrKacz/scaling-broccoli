extends ColorRect

const MIN_RADIUS: float = 1
const OUTER_RADIUS: float = 5
const MAX_RADIUS: float = 2
const MAX_LEVEL: float = 2 # combo/radius: 2-9/2 ; 10-19/1.5 ; 20+/1
const RADIUS_STEP: float = (MAX_LEVEL - MIN_RADIUS) / MAX_LEVEL

var tween: Tween

var level: int = -1:
	get:
		return level
	set(value):
		value = clamp(value, -1, MAX_LEVEL)
		if value == level:
			return
		level = value
		reset_tween()
		if level == -1:
			# need to set and remove visible to not overload tree
			tween.tween_property(material, "shader_parameter/radius", OUTER_RADIUS, 0.5)
			tween.tween_callback(set_visible.bind(false))
		elif level == 0:
			# need to set and remove visible to not overload tree
			tween.tween_callback(set_visible.bind(true))
			tween.tween_property(material, "shader_parameter/radius", MAX_RADIUS, 0.5)
		else:
			tween.tween_property(material, "shader_parameter/radius", MAX_RADIUS - RADIUS_STEP * level, 0.5)

func reset_tween():
	if tween:
		tween.kill() # Abort the previous animation.
	tween = get_tree().create_tween().bind_node(self)

func _on_tree_exiting():
	material.set_shader_parameter("radius", OUTER_RADIUS)
