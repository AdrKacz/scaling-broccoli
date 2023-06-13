extends Control

@onready var golds_label: Label = $MarginContainer/VBoxContainer/Gold/Control/Sprite2D/Label
@onready var golds_sprite: Sprite2D = $MarginContainer/VBoxContainer/Gold/Control/Sprite2D
@onready var streaks_label: Label = $MarginContainer/VBoxContainer/Streak/Control/Sprite2D/Label
@onready var streaks_sprite: Sprite2D = $MarginContainer/VBoxContainer/Streak/Control/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	golds_label.text = str(Memory.golds)
	Memory.update_golds.connect(_on_memory_update_golds)
	
	streaks_label.text = str(Memory.streaks)
	Memory.update_streaks.connect(_on_memory_update_streaks)

func pulse(tween, sprite):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.3)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.2)

var golds_tween : Tween
func _on_memory_update_golds(_delta: int):
	pulse(golds_tween, golds_sprite)
	golds_label.text = str(Memory.golds)

var streaks_tween : Tween
func _on_memory_update_streaks(_delta: int):
	pulse(streaks_tween, streaks_sprite)
	streaks_label.text = str(Memory.streaks)
