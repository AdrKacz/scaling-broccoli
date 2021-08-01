extends Node

# Helpers
func populate_array(length, value):
	var local_array = []
	for i in length:
		local_array.append(value)
	return local_array

# Shockwave
const shockwave_force = 0.5
const shockwave_thickness = 0.01
const shockwave_force_strong = 1.0
const shockwave_thickness_strong = 0.2


# Gameplay
const can_be_background_state = true
const maximum_time = 300 # in seconds


# State Manager
enum GameModeEnum { # Use an array below to differentiate params for different mode 
	GameUni,
	GameKalei
}

const combo_level_to_params = [ # index to seconds
	{"swap_time": [3.0, 3.0], "time_bonus_to_next": 1, "time_malus": 5}, # no combo_swap_spawn at combo level 0
	{"swap_time": [0.6, 0.9], "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": [0.6, 0.8], "combo_swap_spawn": 4, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": [0.6, 0.7], "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": [0.5, 0.7], "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": [0.5, 0.6], "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": [0.5, 0.6], "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": [0.4, 0.5], "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": [0.4, 0.5], "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": [0.4, 0.4], "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": [0.4, 0.4], "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
	{"swap_time": 0.3, "combo_swap_spawn": 5, "time_bonus_to_next": 1, "time_malus": 5},
]


# ===== ===== =====
# Color definitions
enum StateEnum {
	YELLOW,
	RED,
	PURPLE,
	BLUE,
	GREEN
}

const State = {
	StateEnum.YELLOW: Color("#F6C362"),
	StateEnum.RED: Color("#DE5E59"),
	StateEnum.PURPLE: Color("#9558F1"),
	StateEnum.BLUE: Color("#79D7F0"),
	StateEnum.GREEN: Color("#64Bf60"),
}
# ==== ===== =====
# Variables definitions
var game_mode = 0 setget setter_game_mode, getter_game_mode
var combo_level = 0 setget setter_combo_level, getter_combo_level
var swap_time = 0 setget setter_swap_time, getter_swap_time
var combo_time = 0 setget setter_combo_time, getter_combo_time
var time_bonus_to_next = 0 setget setter_time_bonus_to_next, getter_time_bonus_to_next
var time_malus = 0 setget setter_time_malus, getter_time_malus

var swap_left_before_combo_ends = 0 setget setter_swap_left_before_combo_ends, getter_swap_left_before_combo_ends


# Game mode
func setter_game_mode(new_value):
	game_mode = clamp(new_value, 0, GameModeEnum.size() - 1)
	return game_mode

func getter_game_mode():
	return game_mode

# Combo level
func setter_combo_level(new_value):
	combo_level = clamp(new_value, 0, combo_level_to_params.size() - 1)
	swap_left_before_combo_ends = generic_getter("combo_swap_spawn") + 1 # +1 to count for the swap from the  combo level upgrade
	return combo_level

func getter_combo_level():
	return combo_level
	
# Swap left before Combo Ends
func setter_swap_left_before_combo_ends(new_value):
	swap_left_before_combo_ends = clamp(new_value, 0, generic_getter("combo_swap_spawn"))
	return combo_level

func getter_swap_left_before_combo_ends():
	return swap_left_before_combo_ends

# Empty setters
func setter_swap_time(new_value):
	pass
func setter_combo_time(new_value):
	pass
func setter_time_bonus_to_next(new_value):
	pass
func setter_time_malus(new_value):
	pass
	
# Getters
func generic_getter(key):
	var local_base = combo_level_to_params[combo_level].get(key, 0)
	var local_array
	if typeof(local_base) == TYPE_ARRAY:
		local_array = local_base
	else:
		local_array = populate_array(GameModeEnum.size(), local_base)
	
	return local_array[game_mode]
	
func getter_swap_time():
	return generic_getter("swap_time")
	
func getter_combo_time():
	return generic_getter("combo_swap_spawn") * generic_getter("swap_time")
	
func getter_time_bonus_to_next():
	return generic_getter("time_bonus_to_next")
	
func getter_time_malus():
	return generic_getter("time_malus")


#var hardness = 1
#func get_refresh_time(game_name):
#	if game_name == "GameSolo":
#		return 0.38 + 0.4/(hardness*hardness*hardness) + 0.4/(hardness*hardness) + 0.1/hardness
#	elif game_name == "GameKalei":
#		return 0.6 + 0.7/(hardness*hardness*hardness) + 0.2/(hardness*hardness) + 0.1/hardness
#
#func get_max_combo_time():
#	return 1.3 + 2.7/(hardness*hardness*hardness) + 0.6/(hardness*hardness) + 0.5/hardness
#
#func get_bonus_time():
#	return 0.3 + 2/(hardness*hardness*hardness) + 1/(hardness*hardness) + 0.1/hardness
#
#func get_malus_time():
#	return 2 - 1/(hardness*hardness*hardness) - 0.3/(hardness*hardness) - 0.1/hardness
#
#func get_combo_time(game_name, time_elapsed):
#	if game_name == "GameSolo":
#		return get_max_combo_time() - time_elapsed
#	elif game_name == "GameKalei":
#		return get_max_combo_time() - time_elapsed
#
#
#func new_state(red_list=[], swap=0, target=0):
#	var possible_targets = StateEnum.values().duplicate()
#	possible_targets.shuffle()
#	# Make a list that would end during the next combo
#	if swap > 0:
#		possible_targets = possible_targets.slice(0, swap - 1)
#		# Remove the first one if he is red_listed
#		while possible_targets[0] in red_list:
#			possible_targets.pop_front()
#			if possible_targets.size() == 0:
#				break
#		# Make sure the one we want is in it
#		possible_targets.push_front(target)
#		# Shuffle again
#		possible_targets.shuffle()
#	# give the next state already calculated
#	return possible_targets.pop_front()
