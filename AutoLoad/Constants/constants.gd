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
var game_mode = 0:
	get:
		return game_mode
	set(value):
		game_mode = clamp(value, 0, GameModeEnum.size() - 1)

var score = 0:
	get:
		return score
	set(value):
		score = value
		print(score)
		if score >= generic_getter("score_to_next_level"):
			level += 1
		return score

var combo = 0:
	get:
		return combo
	set(value):
		combo = value
		swap_left_before_combo_ends = generic_getter("combo_swap_spawn") + 1

var swap_time = 0:
	get:
		if is_same_state:
			return generic_getter("swap_time_identique")
		return generic_getter("swap_time")
	set(value):
		print('Tried to set swap_time with', value)

var combo_time = 0:
	get:
		return generic_getter("combo_swap_spawn") * generic_getter("swap_time")
	set(value):
		print('Tried to set combo_time with', value)

var time_bonus_to_next = 0:
	get:
		return generic_getter("time_bonus_base") + generic_getter("time_bonus_combo") * combo
	set(value):
		print('Tried to set time_bonus_to_next with', value)
		
var time_malus = 0:
	get:
		return generic_getter("time_malus")
	set(value):
		print('Tried to set time_malus with', value)

var swap_left_before_combo_ends = 0:
	get:
		return swap_left_before_combo_ends
	set(value):
		swap_left_before_combo_ends = clamp(value, 0, generic_getter("combo_swap_spawn") + 1)

var level: int = 0
var is_same_state: bool = false
var pause: bool = false
var sound: bool = true
var music: bool = true

func generic_getter(key):
	var local_base = level_to_params[level].get(key, 0)
	var local_array
	if typeof(local_base) == TYPE_ARRAY:
		local_array = local_base
	else:
		local_array = populate_array(GameModeEnum.size(), local_base)
	
	return local_array[game_mode]
