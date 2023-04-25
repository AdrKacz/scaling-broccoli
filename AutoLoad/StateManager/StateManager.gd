extends Node

var next_background_states = []

# Color functions	
func get_character_next_state(character_state):
	var states = Constants.StateEnum.values().duplicate()
	states.erase(character_state)
	return states.pick_random()

func get_background_next_state(background_state, character_state):
	# list of next states
	if next_background_states.is_empty():
		var states = Constants.StateEnum.values().duplicate()
		var states_size: int = states.size()
		states.shuffle()
		
		# cannot have same background state twice in a row
		var background_state_index: int = states.find(background_state)
		if background_state_index == 0:
			states.pop_front()
			states.push_back(background_state)
	
		# no need to plan further than next match
		var character_state_index: int = states.find(character_state)
		next_background_states = states.slice(0, character_state_index + 1)
	
	# give the next state already calculated
	var next_state = next_background_states.pop_front()
	Constants.state_matches = next_state == character_state
	return next_state
