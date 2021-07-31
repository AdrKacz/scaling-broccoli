extends Node2D

var state = 0
	
	
func change_state(new_state):
	$State.text = str(new_state)
	$Sprite.modulate = Constants.State[new_state]
	state = new_state
