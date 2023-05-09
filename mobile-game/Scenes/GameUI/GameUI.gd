extends Control

@export var BonusText: PackedScene
@export var ChallengeText: PackedScene

var display_bonus_text_position: Vector2
var display_challenge_text_position: Vector2
var computed_safe_area: Rect2

func _ready():
	$ScoreText.text = str(0)
	
	# get position for bonus text
	computed_safe_area = $MarginContainer.computed_safe_area
	$ScoreText.position = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + 96,
	)
	
	display_challenge_text_position = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y * .25,
	)
	$IntroductionText.position = display_challenge_text_position

	display_bonus_text_position = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y * .8,
	)

func _on_pause_button_pressed():
	Session.click()
	get_tree().paused = true
	$MarginContainer/PauseMenu.visible = true
	
func update_score(score):
	$ScoreText.text = str(score)
	$ScoreText.pulse()
	if find_child('IntroductionText', false):
		$IntroductionText.leave()

func display_bonus_text(text):
	var bonus_text = BonusText.instantiate()
	bonus_text.text = text
	bonus_text.position = display_bonus_text_position + Vector2(randf_range(-64, 64), randf_range(-64, 64)) # randomise
	add_child(bonus_text)

func display_challenge_text(text: String, checked: bool):
	var challenge: Sprite2D = ChallengeText.instantiate()
	challenge.challenge_label = text
	challenge.is_checked = checked
	challenge.max_width = computed_safe_area.size.x - 48
	challenge.position = display_challenge_text_position
	add_child(challenge)
