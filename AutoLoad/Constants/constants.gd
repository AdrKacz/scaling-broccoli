extends Node


var max_states = 5
var new_state = 0


func new_state(red_list=[]):
	if red_list.size() >= Constants.max_states:
		print("ERROR, too many states in the red_list Game.gd")
		return 0
	new_state = randi() % Constants.max_states
	while new_state in red_list:
		new_state = randi() % Constants.max_states
	return new_state
