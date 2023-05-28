extends Control

var gold_label: Label
var gold_sprite: Sprite2D
var streak_label: Label
var streak_sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	gold_label = $MarginContainer/VBoxContainer/Gold/Control/Sprite2D/Label
	gold_sprite = $MarginContainer/VBoxContainer/Streak/Control/Sprite2D
	gold_label.text = str(Memory.gold)
	Memory.streak_update.connect(_on_memory_gold_update)
	
	streak_label = $MarginContainer/VBoxContainer/Streak/Control/Sprite2D/Label
	streak_sprite = $MarginContainer/VBoxContainer/Streak/Control/Sprite2D
	streak_label.text = str(Memory.streak)
	Memory.streak_update.connect(_on_memory_streak_update)

func pulse(tween, sprite):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.3)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.2)

var gold_tween : Tween
func _on_memory_gold_update():
	pulse(gold_tween, gold_sprite)
	gold_label.text = str(Memory.gold)

var streak_tween : Tween
func _on_memory_streak_update():
	pulse(streak_tween, streak_sprite)
	streak_label.text = str(Memory.streak)
