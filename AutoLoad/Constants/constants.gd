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

# Refresh time per number of simultaneous games
const ModeWaitTime = {
	1: 0.62,
	2: 0.75,
	4: 1,
	6: 1.6
}
const ModeScore = {
	1: 2,
	2: 1.2,
	4: 1,
	6: 0.9
}
const ModePosition = {
	1: [{
		"x": 0,
		"y": 0
	}],
	2:  [{
		"x": 0,
		"y": 0
	},{
		"x": 0,
		"y": 640
	}],
	4:  [{
		"x": 0,
		"y": 0
	},{
		"x": 0,
		"y": 640
	},{
		"x": 360,
		"y": 0
	},{
		"x": 360,
		"y": 640
	}],
	6:  [{
		"x": 0,
		"y": 0
	},{
		"x": 0,
		"y": 426.6
	},{
		"x": 0,
		"y": 853.2
	},{
		"x": 360,
		"y": 0
	},{
		"x": 360,
		"y": 426.6
	},{
		"x": 360,
		"y": 853.2
	}]
}
const ModeScale = {
	1: {
		"x": 1,
		"y": 1
	},
	2:  {
		"x": 1,
		"y": 0.5
	},
	4:  {
		"x": 0.5,
		"y": 0.5
	},
	6:  {
		"x": 0.5,
		"y": 0.34
	}
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
