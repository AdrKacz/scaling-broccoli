extends CanvasLayer
signal on_screen

@onready var hearts: MarginContainer =  $Control/MarginContainer/CenterContainer/VBoxContainer/Hearts
@onready var play: TextureButton = $Control/MarginContainer/CenterContainer/VBoxContainer/Play
@onready var buy_heart: TextureButton = $Control/MarginContainer/CenterContainer/VBoxContainer/BuyHeart
@onready var label: Label = $Control/MarginContainer/CenterContainer/VBoxContainer/Label

func _ready():
	if Memory.challenge_completed:
		hearts.visible = false
	elif Memory.hearts <= 1: # if one lives, will lose it
		play.visible = false
		buy_heart.visible = true
		Memory.update_hearts.connect(_on_memory_update_hearts)
	appear()
	
func _on_memory_update_hearts(_delta: int):
	var has_hearts: bool = Memory.hearts > 0
	play.visible = has_hearts
	buy_heart.visible = not has_hearts
	
func update_appear_radius(radius: float):
	$Control.material.set_shader_parameter("radius", radius)
	$UIBackground.material.set_shader_parameter("radius", radius)
	
func lose_heart():
	Memory.hearts -= 1

var tween: Tween
func appear():
	if tween:
		tween.kill()
	$Control.visible = true
	$Control/BlockTouch.visible = true
	tween = create_tween().bind_node(self).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT_IN)
	if hearts.visible:
		tween.tween_callback(lose_heart)
	tween.tween_method(update_appear_radius, 0., 1., 1.)
	tween.tween_callback($Control/BlockTouch.set_visible.bind(false))
	tween.tween_callback(emit_signal.bind("on_screen"))

func _on_play_pressed():
	Session.click()
	Session.change_node_to_challenge(Memory.get_challenge())
