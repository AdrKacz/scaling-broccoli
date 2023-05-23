extends Node

# Gameplay
const background_delta: float = 0.5
const background_match_delta: float = 0.75
const score_factor: int = 10

const max_swaps: Array[int] = [5, 4, 3]

const min_life = 0
const max_life = 3

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

var config: ConfigFile

var challenge_completed: bool:
	get:
		return challenge_completed
	set(value):
		challenge_completed = value
		config.set_value('parameters', 'challenge_completed', challenge_completed)
		config.save("user://parameters.cfg")

var remaining_lives: int:
	get:
		return remaining_lives
	set(value):
		remaining_lives = clamp(value, min_life, max_life)
		config.set_value('parameters', 'remaining_lives', remaining_lives)
		config.set_value('parameters', 'last_update_datetime', Time.get_datetime_string_from_system())
		config.save("user://parameters.cfg")

func _ready():
	config = ConfigFile.new()
	var err = config.load("user://parameters.cfg")
	if err != OK:
		remaining_lives = max_life
		challenge_completed = false
	read_remaining_lives_from_memory()
	read_challenge_completed_from_memory()
	
func read_challenge_completed_from_memory():
	challenge_completed = config.get_value('parameters', 'challenge_completed', false)

func read_remaining_lives_from_memory():
	var last_remaining_lives: int = config.get_value('parameters', 'remaining_lives', max_life)
	if is_same_update_day(config.get_value('parameters', 'last_update_datetime', "")):
		remaining_lives = last_remaining_lives
	else:
		remaining_lives = max_life

func is_same_update_day(last_update_datetime) -> bool:
	if last_update_datetime == "":
		return false
	var today_datetime_dict: Dictionary = Time.get_datetime_dict_from_system()
	var last_update_datetime_dict: Dictionary = Time.get_datetime_dict_from_datetime_string(last_update_datetime, false)
	if is_same_day(today_datetime_dict, last_update_datetime_dict):
		return true
	return false

func is_same_day(date_a: Dictionary, date_b: Dictionary) -> bool:
	if date_a.day != date_b.day:
		return false
	if date_a.month != date_b.month:
		return false
	if date_a.year != date_b.year:
		return false
	return true
