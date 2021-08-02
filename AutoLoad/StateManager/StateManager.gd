extends Node

var possible_targets = []
var keep_mode = false

# Color functions
func get_next_state_from(states):
	return Constants.StateEnum.BLUE
	
func get_state_from_list_with_biases(states, biases):
	return Constants.StateEnum.PURPLE
	
func get_character_next_state(background_state, character_state):
	return randi() % Constants.StateEnum.size()

func get_background_next_state(background_state, character_state):
	# Make a list that would end during the next combo
	if possible_targets.size() == 0:
		possible_targets = Constants.StateEnum.values().duplicate()
		possible_targets.erase(character_state)
		possible_targets.shuffle()
		if Constants.swap_left_before_combo_ends != 0:
			possible_targets = possible_targets.slice(0, Constants.swap_left_before_combo_ends - 3)
		# Make sure the one we want is in it
		possible_targets.push_front(character_state)
		# Shuffle again
		possible_targets.shuffle()
		# Remove the first one if he already passed
		while possible_targets[0] == background_state:
			possible_targets.shuffle()
	
	# give the next state already calculated
	var next_state = possible_targets.pop_front()
	if next_state == character_state:
		Constants.is_same_state = true
	else:
		Constants.is_same_state = false
	return next_state
