extends Sprite2D

var is_leaving: bool = false
var tween: Tween
func _ready():
	scale = Vector2(0, 0)
	enter()
	
func animate():
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)

func enter():
	animate()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_interval(2)
	tween.tween_property(self, "scale", Vector2(1, 1), 1)
	
func leave():
	if is_leaving:
		return # don't leave twice
	is_leaving = true
	animate()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(0, 0), 1)
	tween.tween_callback(self.queue_free)

