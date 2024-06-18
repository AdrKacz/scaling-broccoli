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
var smash_strike: int = 0 # different than combo strike as it doesn't count bonus from hammers
var combos_strike: int = 0
var local_combos_strike: int = 0 # used only within a stage to know when to go to next one

func get_card_level(combo_required: int) -> int:
	if combo_required < 20:
		return 1
	elif combo_required < 50:
		return 2
	else:
		return 3
		
func dir_contents(path, filter=null):
	var dir = DirAccess.open(path)
	var file_names: Dictionary = {}
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.get_extension() == 'import' and (filter and file_name.contains(filter) or not filter):
					file_names[file_name.replace('.import', '')] = true
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	var array: Array[String] = []
	array.assign(file_names.keys())
	array.sort_custom(func(a, b): return a.naturalnocasecmp_to(b) < 0)
	return array
