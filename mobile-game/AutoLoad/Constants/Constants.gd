extends Node

# Gameplay
const background_delta: float = 0.5
const background_match_delta: float = 0.75

const max_swaps: Array[int] = [5, 4, 3]

var state_matches: bool = false
var swap_delta: float:
	get:
		if state_matches:
			return background_match_delta
		return background_delta
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
var combos_strike: int = 0
var local_combos_strike: int = 0 # used only within a stage to know when to go to next one
var stage: int = 1

var local_combo_for_next_stage: int:
	get:
		if stage < 5:
			return stage
		elif stage < 10:
			return 2 * stage
		elif stage < 15:
			return 4 * stage
		else:
			return 8 * stage
