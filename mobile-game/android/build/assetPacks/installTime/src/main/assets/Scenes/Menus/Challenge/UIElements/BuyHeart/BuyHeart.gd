extends TextureButton

const offset_position: Vector2 = Vector2(32, 0)

var initial_position: Vector2
func _ready():
	await get_tree().process_frame
	initial_position = position

var tween: Tween
func animate_buy_heart():
	if tween:
		tween.kill() # Abort the previous animation.
	else:
		initial_position = position # reassign if not in animation to not have shift on multi taps
	tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", initial_position + offset_position, .1)
	tween.tween_property(self, "position", initial_position - offset_position, .1)
	tween.tween_property(self, "position", initial_position, .1)


func _on_pressed():
	Session.click()
	if Memory.golds >= Constants.golds_to_life:
		Memory.golds -= 1
		Memory.hearts += 3
	else:
		animate_buy_heart()
