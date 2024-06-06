extends CanvasLayer
signal exit

@export var Card: PackedScene
@export var LockedCard: PackedScene


func _on_exit_texture_button_pressed():
	emit_signal("exit")

func _on_card_pressed(stage: int):
	$CardFullScreen.texture_normal = load("res://assets/Cards/Level_" + str(stage) + ".jpeg")
	$CardFullScreen.visible = true

func _on_card_full_screen_pressed():
	$CardFullScreen.visible = false


func _on_visibility_changed():
	if not visible:
		return
	# TODO: we want to cache the results to not re-initiate all cards everytime
	for n in $Control/ScrollContainer/HFlowContainer.get_children():
		$Control/ScrollContainer/HFlowContainer.remove_child(n)
		n.queue_free()
	for i in 5: # Add all card unlocked (hardcoded maximum number of levels is 5)
		if i + 1 < Memory.stage:
			var card = Card.instantiate()
			card.stage = i + 1
			card.pressed.connect(_on_card_pressed.bind(i + 1))
			$Control/ScrollContainer/HFlowContainer.add_child(card)
		else:
			var locked_card = LockedCard.instantiate()
			$Control/ScrollContainer/HFlowContainer.add_child(locked_card)