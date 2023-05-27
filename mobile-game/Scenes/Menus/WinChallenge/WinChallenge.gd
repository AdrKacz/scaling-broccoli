extends CanvasLayer
signal on_screen

func _ready():
	appear()
	
func update_appear_radius(radius: float):
	$Control.material.set_shader_parameter("radius", radius)
	$UIBackground.material.set_shader_parameter("radius", radius)
	
func complete_challenge():
	Memory.challenge_completed = true
	Memory.lightning += 1

var tween: Tween
func appear():
	if tween:
		tween.kill()
	$Control.visible = true
	$Control/BlockTouch.visible = true
	tween = create_tween().bind_node(self).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT_IN)
	tween.tween_method(update_appear_radius, 0., 1., 1.)
	if not Memory.challenge_completed:
		tween.tween_callback(complete_challenge)
	tween.tween_callback($Control/BlockTouch.set_visible.bind(false))
	tween.tween_callback(emit_signal.bind("on_screen"))

func _on_play_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster)
