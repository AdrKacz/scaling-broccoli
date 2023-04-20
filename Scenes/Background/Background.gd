extends Node2D

var state = 0
	
func change_state(new_state):
	$Sprite2D.modulate = Constants.State[new_state]
	state = new_state
