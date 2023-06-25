extends Node
signal update_golds(delta: int)
signal update_streaks(delta: int)
signal update_hearts(delta: int)

const min_hearts: int = 0
const max_hearts: int = 3

var config: ConfigFile

var golds: int:
	get:
		return golds
	set(value):
		value = max(0, value)
		var delta: int = value - golds
		golds = value
		config.set_value('parameters', 'golds', golds)
		config.save("user://parameters.cfg")
		emit_signal("update_golds", delta)

# points to get a gold reward (every Constants.point_to_reward)
var reward_points: int:
	get:
		return reward_points
	set(value):
		reward_points = clamp(0, Constants.point_to_reward, value)
		config.set_value('parameters', 'reward_points', reward_points)
		config.save("user://parameters.cfg")

var streaks: int:
	get:
		return streaks
	set(value):
		value = max(0, value)
		var delta: int = value - streaks
		streaks = value
		config.set_value('parameters', 'streaks', streaks)
		config.save("user://parameters.cfg")
		emit_signal("update_streaks", delta)

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

var hearts: int:
	get:
		return hearts
	set(value):
		value = clamp(value, min_hearts, max_hearts)
		var delta: int = value - hearts
		hearts = value
		config.set_value('parameters', 'hearts', hearts)
		config.save("user://parameters.cfg")
		emit_signal("update_hearts", delta)

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
	
func get_challenge() -> Dictionary:
	var challenge_args: Dictionary = config.get_value('challenge', 'args', {})
	var challenge: Dictionary
	if challenge_args.has('name'):
		challenge = Challenges.getter[challenge_args['name']].call(challenge_args)
	else:
		challenge = Challenges.getter.values().pick_random().call()
		config.set_value('challenge', 'args', challenge.get('args'))
		config.save("user://parameters.cfg")
	return challenge
	

func reset_resources():
	streaks = 0
	reward_points = 0

func reset_challenge():
	hearts = max_hearts
	challenge_completed = false
	config.set_value('challenge', 'args', null) # prepare to reset challenge

func read_resources_from_memory():
	streaks = config.get_value('parameters', 'streaks', 0)
	reward_points = config.get_value('parameters', 'reward_points', 0)
	golds = config.get_value('parameters', 'golds', 0)
	
func read_challenge_from_memory():
	var today_datetime: String = Time.get_datetime_string_from_system()
	
	var local_hearts = config.get_value('parameters', 'hearts', max_hearts)
	var local_challenge_completed = config.get_value('parameters', 'challenge_completed', false) 

	if is_same_day(last_day_played, today_datetime):
		print('Last played today')
		hearts = local_hearts
		challenge_completed = local_challenge_completed
	elif is_same_day(get_next_day(last_day_played), today_datetime):
		print('Last played yesterday')
		if not local_challenge_completed:
			print('Challenge was not completed')
			streaks = 0 # challenge not succeeded yesterday
		reset_challenge()
	else:
		print('Last played before yesterday')
		streaks = 0 # streak lost
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
