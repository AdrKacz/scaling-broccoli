extends CanvasLayer

var allowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -_1234567890"

func set_visible_to(value):
	$Control.visible = value
	$Control/CenterContainer/VBox/Score.text = str(Constants.score)


func _on_SubmitScore_pressed():
	$ClickSound.play()
	var name = $Control/CenterContainer/VBox/VBoxContainer/Name.text
	for letter in name:
		if not letter in allowed: # TODO Hello Regex
			$Control/CenterContainer/VBox/VBoxContainer/Name.text = "Not valid"
			return
	if name.length() <= 2:
		$Control/CenterContainer/VBox/VBoxContainer/Name.text = "Too short"
		return
	Session.submit_score(Constants.score, name)


func _on_MainMenu_pressed():
	$ClickSound.play()
	Session.main_menu()


func _on_Restart_pressed():
	$ClickSound.play()
	Session.start_game()
