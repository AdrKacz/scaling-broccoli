extends Sprite2D

var animation_duration: float = 0.5
var interval_duration: float = 0.5
var initial_interval_duration: float = 1.

@onready var original_custom_minimum_size: Vector2 = $CenterContainer/HBoxContainer/Star1.custom_minimum_size
var tween: Tween
var number_of_visible: int:
	get:
		var count: int = 0
		for child in $CenterContainer/HBoxContainer.get_children():
			if child.visible:
				count += 1
		return count
	set(value):
		value = clamp(value, 0, 3)
		if value > 0:
			if tween:
				tween.kill()
			tween = get_tree().create_tween().bind_node(self).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			tween.tween_interval(initial_interval_duration)
			var children: Array[Node] = $CenterContainer/HBoxContainer.get_children()
			for i in children.size():
				children[i].custom_minimum_size = Vector2(0, 0)
				children[i].visible = i < value
				if children[i].visible:
					tween.tween_property(children[i], "custom_minimum_size", original_custom_minimum_size, animation_duration)
					tween.tween_interval(interval_duration)
		else:
			for child in $CenterContainer/HBoxContainer.get_children():
				child.visible = false
