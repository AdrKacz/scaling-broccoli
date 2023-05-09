extends Sprite2D

@export var max_width: float = 0
@export var is_checked: bool = false
@export var challenge_label: String = "Do a combo x20"

func _ready():
	scale = Vector2(0, 0)
	$CenterContainer/HBoxContainer/Label.custom_minimum_size = Vector2(max_width, 0)
	$CenterContainer/HBoxContainer/Label.text = challenge_label
	$CenterContainer/HBoxContainer/TextureRect.visible = is_checked
	animate()
	
func animate():
	var tween: Tween = create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), 1)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_interval(3)
	tween.tween_property(self, "scale", Vector2(0, 0), 1)
	tween.tween_callback(self.queue_free)
