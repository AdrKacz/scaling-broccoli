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
	var days_since_last_update: int = get_difference_in_day(last_update_datetime, Time.get_date_string_from_system())
	if days_since_last_update == 0:
		remaining_lives = config.get_value('parameters', 'remaining_lives', max_life)
		challenge_completed = config.get_value('parameters', 'challenge_completed', false)
	elif days_since_last_update == 1:
		if not challenge_completed:
			lightning = 0 # challenge not succeeded yesterday
		reset_challenge()
	else:
		lightning = 0 # streak lost
		reset_challenge()
		
func get_difference_in_day(date_a: String, date_b: String) -> int:
	var unix_a: int = Time.get_unix_time_from_datetime_string(date_a)
	var unix_b: int = Time.get_unix_time_from_datetime_string(date_b)
	
	return abs(unix_b - unix_a) / 86400
