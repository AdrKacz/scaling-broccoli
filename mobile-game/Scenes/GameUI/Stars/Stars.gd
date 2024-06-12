extends Sprite2D

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
			tween.tween_interval(1.)
			var children: Array[Node] = $CenterContainer/HBoxContainer.get_children()
			for i in children.size():
				children[i].custom_minimum_size = Vector2(0, 0)
				children[i].visible = i < value
				if children[i].visible:
					tween.tween_property(children[i], "custom_minimum_size", original_custom_minimum_size, 0.5)
					tween.tween_interval(0.5)
		else:
			for child in $CenterContainer/HBoxContainer.get_children():
				child.visible = false


func _ready():
	number_of_visible = 3
