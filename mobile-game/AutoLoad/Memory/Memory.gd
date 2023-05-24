extends Node

signal lightning_update

const min_life = 0
const max_life = 3

var config: ConfigFile

var lightning: int:
	get:
		return lightning
	set(value):
		lightning = value
		config.set_value('parameters', 'lightning', lightning)
		config.save("user://parameters.cfg")
		emit_signal("lightning_update")

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
		reset_challenge()
		lightning = 0
	read_challenge_from_memory()
	read_resources_from_memory()
	reset_challenge()
	
func read_resources_from_memory():
	lightning = config.get_value('parameters', 'lightning', 0)
	
func reset_challenge():
	remaining_lives = max_life
	challenge_completed = false
	
func read_challenge_from_memory():
	var last_update_datetime: String = config.get_value('parameters', 'last_update_datetime', "")
	if is_same_update_day(last_update_datetime):
		remaining_lives = config.get_value('parameters', 'remaining_lives', max_life)
		challenge_completed = config.get_value('parameters', 'challenge_completed', false)
	else:
		reset_challenge()

func is_same_update_day(last_update_datetime: String) -> bool:
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
