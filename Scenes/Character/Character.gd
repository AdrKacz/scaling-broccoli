extends Node2D
signal click

var state = 0


func _on_TextureButton_pressed():
	emit_signal("click", state)

func set_state(not_this_state):
	state = Constants.new_state([state, not_this_state])
	$State.text = str(state)
