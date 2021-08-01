extends Node

const shockwave_force = 0.5
const shockwave_thickness = 0.01
const shockwave_force_strong = 1.0
const shockwave_thickness_strong = 0.2

const can_be_background_state = true

const max_time = 30
const max_combo_swaps = 6

# Pixel per seconds
const combo_time_animation_max_speed = 10


# ===== ===== =====
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

var hardness = 1
func get_refresh_time(game_name):
	if game_name == "GameSolo":
		return 0.38 + 0.4/(hardness*hardness*hardness) + 0.4/(hardness*hardness) + 0.1/hardness
	elif game_name == "GameKalei":
		return 0.6 + 0.7/(hardness*hardness*hardness) + 0.2/(hardness*hardness) + 0.1/hardness

func get_max_combo_time():
	return 1.3 + 2.7/(hardness*hardness*hardness) + 0.6/(hardness*hardness) + 0.5/hardness

func get_bonus_time():
	return 0.3 + 2/(hardness*hardness*hardness) + 1/(hardness*hardness) + 0.1/hardness

func get_malus_time():
	return 2 - 1/(hardness*hardness*hardness) - 0.3/(hardness*hardness) - 0.1/hardness

func get_combo_time(game_name, time_elapsed):
	if game_name == "GameSolo":
		return get_max_combo_time() - time_elapsed
	elif game_name == "GameKalei":
		return get_max_combo_time() - time_elapsed


func new_state(red_list=[], swap=0, target=0):
	var possible_targets = StateEnum.values().duplicate()
	possible_targets.shuffle()
	# Make a list that would end during the next combo
	if swap > 0:
		possible_targets = possible_targets.slice(0, swap - 1)
		# Remove the first one if he is red_listed
		while possible_targets[0] in red_list:
			possible_targets.pop_front()
			if possible_targets.size() == 0:
				break
		# Make sure the one we want is in it
		possible_targets.push_front(target)
		# Shuffle again
		possible_targets.shuffle()
	# give the next state already calculated
	return possible_targets.pop_front()
