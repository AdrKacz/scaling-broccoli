extends Node

signal streak_update

const min_life = 0
const max_life = 3

var config: ConfigFile

var gold: int:
	get:
		return gold
	set(value):
		gold = max(0, value)
		config.set_value('parameters', 'gold', gold)
		config.save("user://parameters.cfg")

# points to get a gold reward (every Constants.point_to_reward)
var reward_points: int:
	get:
		return reward_points
	set(value):
		reward_points = clamp(0, Constants.point_to_reward, value)
		config.set_value('parameters', 'reward_points', reward_points)
		config.save("user://parameters.cfg")

var streak: int:
	get:
		return streak
	set(value):
		streak = value
		config.set_value('parameters', 'streak', streak)
		config.save("user://parameters.cfg")
		emit_signal("streak_update")

var challenge_completed: bool:
	get:
		return challenge_completed
	set(value):
		challenge_completed = value
		config.set_value('parameters', 'challenge_completed', challenge_completed)
		config.save("user://parameters.cfg")
		
var last_day_played: String:
	get:
		return last_day_played
	set(value):
		last_day_played = value
		config.set_value('parameters', 'last_day_played', last_day_played)
		config.save("user://parameters.cfg")

var remaining_lives: int:
	get:
		return remaining_lives
	set(value):
		remaining_lives = clamp(value, min_life, max_life)
		config.set_value('parameters', 'remaining_lives', remaining_lives)
		config.save("user://parameters.cfg")

func _ready():
	config = ConfigFile.new()
	var err = config.load("user://parameters.cfg")
	if err != OK: # never played and file doesn't exit
		reset_challenge()
		reset_resources()
	last_day_played = config.get_value('parameters', 'last_day_played', "")
	if last_day_played == "": # never played but file exist
		reset_challenge()
		reset_resources()
	else:
		read_challenge_from_memory()
		read_resources_from_memory()
	last_day_played = Time.get_datetime_string_from_system() # set to today

func reset_resources():
	streak = 0
	reward_points = 0

func reset_challenge():
	remaining_lives = max_life
	challenge_completed = false

func read_resources_from_memory():
	streak = config.get_value('parameters', 'streak', 0)
	reward_points = config.get_value('parameters', 'reward_points', 0)
	gold = config.get_value('parameters', 'gold', 0)
	
func read_challenge_from_memory():
	var today_datetime: String = Time.get_datetime_string_from_system()
	
	var local_remaining_lives = config.get_value('parameters', 'remaining_lives', max_life)
	var local_challenge_completed = config.get_value('parameters', 'challenge_completed', false) 

	if is_same_day(last_day_played, today_datetime):
		print('Last played today')
		remaining_lives = local_remaining_lives
		challenge_completed = local_challenge_completed
	elif is_same_day(get_next_day(last_day_played), today_datetime):
		print('Last played yesterday')
		if not local_challenge_completed:
			print('Challenge was not completed')
			streak = 0 # challenge not succeeded yesterday
		reset_challenge()
	else:
		print('Last played before yesterday')
		streak = 0 # streak lost
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
