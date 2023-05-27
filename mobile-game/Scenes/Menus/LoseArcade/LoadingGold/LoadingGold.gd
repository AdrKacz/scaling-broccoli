extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgressBar.value = get_progress()

func get_progress():
	@warning_ignore("integer_division")
	return Memory.reward_points / Constants.point_to_reward

func earn_points():
	# get points
	var total_reward_points: int = Memory.reward_points + Constants.score
	@warning_ignore("integer_division")
	var earn_gold: int = total_reward_points / Constants.point_to_reward
	var remaining_points: int = total_reward_points % Constants.point_to_reward
	
	Memory.reward_points = remaining_points
	
	# animate to new_reward points
