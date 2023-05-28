extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgressBar.value = get_progress(Memory.reward_points)

func get_progress(points: int) -> float:
	return 100. * points / Constants.point_to_reward

func earn_golds():
	$TextureRect/Control/AnimationPlayer.play("pop")
	
func earn_points():
	# get points
	var total_reward_points: int = Memory.reward_points + Constants.score
	@warning_ignore("integer_division")
	var gold_earned: int = total_reward_points / Constants.point_to_reward
	var remaining_points: int = total_reward_points % Constants.point_to_reward
	
	Memory.gold += gold_earned # gold animation won't display has no gold
	# Update gold update if you add resources so it increases incrementally
	Memory.reward_points = remaining_points # save remaining points
	
	# animate to new_reward points
	var tween: Tween = create_tween()
	var last_value = $TextureProgressBar.value
	for i in gold_earned: # animate gold earned
		tween.tween_property(
			$TextureProgressBar,
			"value",
			100,
			(100 - last_value) * 1e-2
		)
		tween.tween_callback(earn_golds)
		tween.tween_property($TextureProgressBar, "value", 0, 0)
		last_value = 0
	
	var progress = get_progress(remaining_points)
	tween.tween_property(
		$TextureProgressBar,
		"value",
		progress,
		(progress - last_value) * 1e-2
	)

