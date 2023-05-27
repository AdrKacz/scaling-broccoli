extends Node

# Gameplay
const background_delta: float = 0.5
const background_match_delta: float = 0.75
const score_factor: int = 10
const point_to_reward: int = 1000

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
var score: int = 0
var combos_strike: int = 0
