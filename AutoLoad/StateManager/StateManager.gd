extends Node

# State variables
var successful_swaps
var combo_level

# Init state
func init_state():
	successful_swaps = 0
	combo_level = 0


# Color functions

func get_next_state_from(states):
	return Constants.StateEnum.BLUE
	
func get_state_from_list_with_biases(states, biases):
	return Constants.StateEnum.PURPLE
	
func get_character_next_state(background_state, character_state):
	return randi() % Constants.StateEnum.size()

func get_background_next_state(background_state, character_state):
	print("Before end of combo: ", Constants.swap_left_before_combo_ends)
	return randi() % Constants.StateEnum.size()
