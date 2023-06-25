class_name ComboLabel
extends Control

@onready var current_label: Label = $CurrentSprite/CurrentLabel
@onready var current_sprite: Sprite2D = $CurrentSprite
@onready var next_label: Label = $NextSprite/NextLabel
@onready var next_sprite: Sprite2D = $NextSprite

var current_combo: int

func _ready():
	current_label.text = _get_text(0)
	current_combo = 1
	Constants.update_combo.connect(_on_update_combo)
	
func _update_label(label: Label, _text: String) -> void:
	label.text = _text

func _update_scale(sprite: Sprite2D, _scale: Vector2) -> void:
	sprite.scale = _scale
	
func _update_visible(sprite: Sprite2D, _visible: bool) -> void:
	sprite.visible = _visible
	
func _on_active_tween_finished() -> void:
	if next_tweens.is_empty():
		return
	var tween: Tween = next_tweens.pop_front()
	tween.play()
	active_tween = tween
	
func _get_text(combo: int) -> String:
	if combo == 0:
		combo = 1
	return "%*d" % [3, combo]

var next_tweens: Array[Tween] = []
var active_tween: Tween
func _on_update_combo() -> void:
	var next_combo: int = max(Constants.combos_strike, 1)
	if next_combo == current_combo:
		return

	var next_combo_text: String = _get_text(next_combo)	
	var tween: Tween
	if next_combo > current_combo:
		tween = _increase_combo(next_combo_text)
	else:
		tween = _decrease_combo(next_combo_text)
	current_combo = next_combo
	
	tween.finished.connect(_on_active_tween_finished)
	
	if active_tween and active_tween.is_valid():
		tween.pause()
		next_tweens.push_back(tween)
	else:
		active_tween = tween

func _increase_combo(next_combo_text: String) -> Tween:
	var tween: Tween = create_tween()

	tween.tween_callback(_update_scale.bind(next_sprite, Vector2(1, 0)))
	tween.tween_callback(_update_label.bind(next_label, next_combo_text))
	tween.tween_callback(_update_visible.bind(next_sprite, true))
	
	tween.tween_property(current_sprite, "scale", Vector2(1, 0), .2)
	tween.parallel().tween_property(next_sprite, "scale", Vector2(1, 1), .3)
	
	tween.tween_callback(_update_visible.bind(next_sprite, false))
	
	tween.tween_callback(_update_label.bind(current_label, next_combo_text))
	tween.tween_callback(_update_scale.bind(current_sprite, Vector2(1, 1)))
	
	return tween
	
func _decrease_combo(next_combo_text: String) -> Tween:
	var tween: Tween = create_tween()

	tween.tween_callback(_update_scale.bind(next_sprite, Vector2(1, 1)))
	tween.tween_callback(_update_label.bind(next_label, current_label.text))
	tween.tween_callback(_update_visible.bind(next_sprite, true))
	
	tween.tween_callback(_update_label.bind(current_label, next_combo_text))
	tween.tween_callback(_update_scale.bind(current_sprite, Vector2(1, 0)))
	
	
	tween.tween_property(current_sprite, "scale", Vector2(1, 1), .3)
	tween.parallel().tween_property(next_sprite, "scale", Vector2(1, 0), .2)
	
	tween.tween_callback(_update_visible.bind(next_sprite, false))
	
	return tween
