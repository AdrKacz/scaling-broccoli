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
const maximum_time = 30 # in seconds


# State Manager
enum GameModeEnum { # Use an array below to differentiate params for different mode 
	GameUni,
	GameKalei
}

const level_to_params = [ # index to seconds
	{"swap_time": 0.8, "swap_time_identique": [0.85, 1], "combo_swap_spawn": 5, "time_bonus_base": 3, "time_bonus_combo": 0, "time_malus": 4, "score_to_next_level": 10},
	{"swap_time": 0.8, "swap_time_identique": [0.85, 1], "combo_swap_spawn": 5, "time_bonus_base": 3, "time_bonus_combo": 0, "time_malus": 4, "score_to_next_level": 10}, # no combo_swap_spawn at combo level 0
	{"swap_time": 0.6, "swap_time_identique": [0.65, 0.9], "combo_swap_spawn": 5, "time_bonus_base": 2.5, "time_bonus_combo": 0.5, "time_malus": 5, "score_to_next_level": 100}, # no combo_swap_spawn at combo level 0
	{"swap_time": 0.45, "swap_time_identique": [0.53, 0.8], "combo_swap_spawn": 6, "time_bonus_base": 2, "time_bonus_combo": 0.5, "time_malus": 6, "score_to_next_level": 63}, # Survivable a l'infini pas trop dur
	{"swap_time": 0.4, "swap_time_identique": [0.45, 0.7], "combo_swap_spawn": 6, "time_bonus_base": 1, "time_bonus_combo": 0.5, "time_malus": 4.5, "score_to_next_level": 103}, # Dur a survivre, encore bon, dur
	{"swap_time": 0.35, "swap_time_identique": [0.41, 0.7], "combo_swap_spawn": 6, "time_bonus_base": 2, "time_bonus_combo": 0.5, "time_malus": 4.3, "score_to_next_level": 189}, # techniiique!
	{"swap_time": 0.3, "swap_time_identique": [0.35, 0.7], "combo_swap_spawn": 7, "time_bonus_base": 2.3, "time_bonus_combo": 0.5, "time_malus": 4.3, "score_to_next_level": 283}, # siii dur, encore faisable si t'es bouillotte
	{"swap_time": 0.28, "swap_time_identique": [0.33, 0.6], "combo_swap_spawn": 7, "time_bonus_base": 2.3, "time_bonus_combo": 0.5, "time_malus": 4.3, "score_to_next_level": 365}, # siii dur, encore faisable si t'es bouillotte
	{"swap_time": 0.27, "swap_time_identique": [0.31, 0.5], "combo_swap_spawn": 8, "time_bonus_base": 2.3, "time_bonus_combo": 0.5, "time_malus": 4.3, "score_to_next_level": 460}, # siii dur, encore faisable si t'es bouillotte
	{"swap_time": 0.25, "swap_time_identique": [0.27, 0.4], "combo_swap_spawn": 9, "time_bonus_base": 3, "time_bonus_combo": 0.5, "time_malus": 4.5, "score_to_next_level": INF},
]
# liste des scores pour monter de tous les niveaux 
# Sans jamais perdre de combo 10,62,188,420,1160,11760
# En perdant le combo         10,30,60 ,100, 150,  210,280,360, 450, 550, 660, 780, 910
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
var score = 0 setget setter_score, getter_score
var level = 0 setget setter_level, getter_level
var combo = 0 setget setter_combo, getter_combo
var swap_time = 0 setget setter_swap_time, getter_swap_time
var combo_time = 0 setget setter_combo_time, getter_combo_time
var time_bonus_to_next = 0 setget setter_time_bonus_to_next, getter_time_bonus_to_next
var time_malus = 0 setget setter_time_malus, getter_time_malus
var is_same_state = false setget setter_is_same_state
var pause = false setget setter_pause, getter_pause

var swap_left_before_combo_ends = 0 setget setter_swap_left_before_combo_ends, getter_swap_left_before_combo_ends


# Game mode
func setter_game_mode(new_value):
	game_mode = clamp(new_value, 0, GameModeEnum.size() - 1)
	return game_mode

func getter_game_mode():
	return game_mode

# Level
func setter_level(new_value):
	level = new_value
	return level

func getter_level():
	return level
	
# Score
func setter_score(new_value):
	score = new_value
	print(score)
	if score >= generic_getter("score_to_next_level"):
		level += 1
	return score
	
func getter_score():
	return score

# Combo
func setter_combo(new_value):
	combo = new_value
	setter_swap_left_before_combo_ends(generic_getter("combo_swap_spawn") + 1)
	return combo

func getter_combo():
	return combo

# Pause
func setter_pause(new_value):
	pause = new_value
	return pause

func getter_pause():
	return pause
	
# Swap left before Combo Ends
func setter_swap_left_before_combo_ends(new_value):
	swap_left_before_combo_ends = clamp(new_value, 0, generic_getter("combo_swap_spawn") + 1)
	return swap_left_before_combo_ends

func getter_swap_left_before_combo_ends():
	return swap_left_before_combo_ends

func setter_is_same_state(new_value):
	is_same_state = new_value
	return is_same_state

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
	var local_base = level_to_params[level].get(key, 0)
	var local_array
	if typeof(local_base) == TYPE_ARRAY:
		local_array = local_base
	else:
		local_array = populate_array(GameModeEnum.size(), local_base)
	
	return local_array[game_mode]
	
func getter_swap_time():
	if is_same_state:
		return generic_getter("swap_time_identique")
	return generic_getter("swap_time")
	
func getter_combo_time():
	return generic_getter("combo_swap_spawn") * generic_getter("swap_time")
	
func getter_time_bonus_to_next():
	return generic_getter("time_bonus_base") + generic_getter("time_bonus_combo") * combo
	
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
