extends Control


var rainbow_label: Label
var lightning_label: Label
var lightning_sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	lightning_label = $MarginContainer/VBoxContainer/Lightning/Control/Sprite2D/Label
	lightning_sprite = $MarginContainer/VBoxContainer/Lightning/Control/Sprite2D
	lightning_label.text = str(Memory.lightning)
	Memory.lightning_update.connect(_on_memory_lightning_update)

var tween = create_tween()
func pulse():
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(lightning_sprite, "scale", Vector2(1.3, 1.3), 0.3)
	tween.tween_property(lightning_sprite, "scale", Vector2(1, 1), 0.2)
	
func _on_memory_lightning_update():
	pulse()
	lightning_label.text = str(Memory.lightning)
	print(lightning_label.text)
	print(Memory.lightning)
