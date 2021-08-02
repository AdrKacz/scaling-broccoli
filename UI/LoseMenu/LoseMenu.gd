extends CanvasLayer

var allowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -_1234567890"

func set_visible_to(value):
	$Control.visible = value
	$Control/CenterContainer/VBox/Score.text = str(Constants.score)


func _on_SubmitScore_pressed():
	$ClickSound.play()
	var name = $Control/CenterContainer/VBox/VBoxContainer/Name.text
	var errorMessage = ""
	for letter in name:
		if not letter in allowed: # TODO Hello Regex	
			errorMessage = "Not valid"		
	if name.length() != 3:
		errorMessage = "Too short"
	
	if errorMessage.length() > 0:
		var initial_text = $Control/CenterContainer/VBox/VBoxContainer/SubmitScore/CenterContainer/Label.text
		$Control/CenterContainer/VBox/VBoxContainer/SubmitScore/CenterContainer/Label.text = errorMessage
		yield(get_tree().create_timer(1), "timeout")
		$Control/CenterContainer/VBox/VBoxContainer/SubmitScore/CenterContainer/Label.text = initial_text
	else:	
		Session.submit_score(Constants.score, name.to_upper())


func _on_MainMenu_pressed():
	$ClickSound.play()
	Session.main_menu()


func _on_Restart_pressed():
	$ClickSound.play()
	Session.start_game()
