extends Node


const can_be_background_state = true
const background_wait_time = 0.4

const max_time = 30
const max_combo_time = 2

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
	StateEnum.PURPLE: Color("#A36DF4"),
	StateEnum.BLUE: Color("#59C2DE"),
	StateEnum.GREEN: Color("#6AFF63"),
}
# ==== ===== =====


func new_state(red_list=[]):
	if red_list.size() >= StateEnum.size():
		print("ERROR, too many states in the red_list Game.gd")
		return null

	var state = randi() % StateEnum.size()
	while state in red_list:
		state = randi() % StateEnum.size()

	return state
