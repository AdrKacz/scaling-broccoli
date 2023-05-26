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
	if last_update_datetime == "":
		reset_challenge()
		lightning = 0
	
	var today_datetime: String = Time.get_datetime_string_from_system()
	
	var local_remaining_lives = config.get_value('parameters', 'remaining_lives', max_life)
	var local_challenge_completed = config.get_value('parameters', 'challenge_completed', false) 
	if is_same_day(last_update_datetime, today_datetime):
		print('Last update same day')
		remaining_lives = local_remaining_lives
		challenge_completed = local_challenge_completed
	elif is_same_day(get_next_day(last_update_datetime), today_datetime):
		print('Last update yesterday')
		if not local_challenge_completed:
			print('Challenge was not completed')
			lightning = 0 # challenge not succeeded yesterday
		reset_challenge()
	else:
		print('Last update before yesterday')
		lightning = 0 # streak lost
		reset_challenge()

func get_next_day(date_string: String) -> String:
	var date_unix: int = Time.get_unix_time_from_datetime_string(date_string)
	date_unix += 86400 # number of seconds in a day
	return Time.get_datetime_string_from_unix_time(date_unix)

func is_same_day(date_string_a: String, date_string_b: String) -> bool:
	var date_a: Dictionary = Time.get_datetime_dict_from_datetime_string(date_string_a, false)
	var date_b: Dictionary = Time.get_datetime_dict_from_datetime_string(date_string_b, false)
	if date_a.day != date_b.day:
		return false
	if date_a.month != date_b.month:
		return false
	if date_a.year != date_b.year:
		return false
	return true
