extends CanvasLayer
signal on_screen

@onready var hearts: MarginContainer =  $Control/MarginContainer/CenterContainer/VBoxContainer/Hearts
@onready var play: TextureButton = $Control/MarginContainer/CenterContainer/VBoxContainer/Play
@onready var buy_heart: TextureButton = $Control/MarginContainer/CenterContainer/VBoxContainer/BuyHeart

func _ready():
	if Memory.remaining_lives <= 1: # if one lives, will lose it
		play.visible = false
		buy_heart.visible = true
	if Memory.challenge_completed:
		hearts.visible = false
	appear()
	
func update_appear_radius(radius: float):
	$Control.material.set_shader_parameter("radius", radius)
	$UIBackground.material.set_shader_parameter("radius", radius)

var tween: Tween
func appear():
	if tween:
		tween.kill()
	$Control.visible = true
	$Control/BlockTouch.visible = true
	tween = create_tween().bind_node(self).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT_IN)
	if hearts.visible:
		tween.tween_callback(hearts.lose_heart)
	tween.tween_method(update_appear_radius, 0., 1., 1.)
	tween.tween_callback($Control/BlockTouch.set_visible.bind(false))
	tween.tween_callback(emit_signal.bind("on_screen"))

func _on_play_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster, {
		"is_challenge": true,
		"end_challenge_condition": func () -> bool:
			if Constants.combos_strike >= 20:
				return true
			return false
	})
