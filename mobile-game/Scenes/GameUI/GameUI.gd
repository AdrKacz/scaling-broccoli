extends Control

@export var BonusText: PackedScene

var display_bonus_text_position: Vector2

func _ready():
	# get position for bonus text
	var computed_safe_area: Rect2 = $MarginContainer.computed_safe_area
	$StageText.position = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y - 96,
	)
	
	$IntroductionText.position = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y * .25,
	)

	display_bonus_text_position = Vector2(
		computed_safe_area.position.x + computed_safe_area.size.x * .5,
		computed_safe_area.position.y + computed_safe_area.size.y * .8,
	)

func _on_settings_button_pressed():
	Session.click()
	get_tree().paused = true
	$MarginContainer/PauseControl/SettingsMarginContainer.visible = false
	$MarginContainer/Settings.visible = true
	
func _on_settings_exit():
	Session.click()
	get_tree().paused = false
	$MarginContainer/PauseControl/SettingsMarginContainer.visible = true 
	$MarginContainer/Settings.visible = false
	
func remove_introduction_text():
	if find_child('IntroductionText', false):
		$IntroductionText.leave()

func display_bonus_text(text):
	var bonus_text = BonusText.instantiate()
	bonus_text.text = text
	bonus_text.position = display_bonus_text_position + Vector2(randf_range(-64, 64), randf_range(-64, 64)) # randomise
	add_child(bonus_text)


func _on_book_texture_button_pressed():
	Session.click()
	get_tree().paused = true
	$MarginContainer/PauseControl/BookMarginContainer.visible = false
	$MarginContainer/Book.visible = true


func _on_book_exit():
	Session.click()
	get_tree().paused = false
	$MarginContainer/PauseControl/BookMarginContainer.visible = true 
	$MarginContainer/Book.visible = false
