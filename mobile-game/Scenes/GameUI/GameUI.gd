extends Control

var display_bonus_text_position: Vector2

func _ready():
	# get position for bonus text
	var computed_safe_area: Rect2 = $MarginContainer.computed_safe_area

	$IntroductionText.position = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y * .25,
	)
	
	Constants.update_score.connect(_on_update_score)

func _on_pause_button_pressed():
	Session.click()
	get_tree().paused = true
	$MarginContainer/PauseMenu.visible = true
	
func _on_update_score() -> void:
	if find_child('IntroductionText', false):
		$IntroductionText.leave()
