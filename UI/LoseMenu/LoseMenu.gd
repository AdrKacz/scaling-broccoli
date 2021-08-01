extends Control

var score = -1
var allowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -_1234567890"

func _ready():
	$Margin/VBox/VBox/Score.text = "Congratulations, you scored a total of " + str(score) + " points! Fill your name and see where you are in the leaderboard!"
	
	
	
func _on_SubmitScore_pressed():
	var name = $Margin/VBox/VBox/Name.text
	print(name)
	for letter in name:
		if not letter in allowed:
			$Margin/VBox/VBox/Name.text = "Letters, numbers, spaces and hyphens only"
			return
	if name.length() >= 40:
		$Margin/VBox/VBox/Name.text = "Please consider less than 40 chars for your name!"
		return
	if name.length() <= 2:
		$Margin/VBox/VBox/Name.text = "A bit more letters?"
		return
	Session.submit_score(score, name)


func _on_MainMenu_pressed():
	Session.main_menu()


func _on_Restart_pressed():
	Session.start_game()
