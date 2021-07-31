extends Control

var score = 0


func _on_SubmitScore_pressed():
	Session.submit_score(score, $Vbox/Hbox/Name.text)


func _on_MainMenu_pressed():
	Session.main_menu()


func _on_Restart_pressed():
	Session.start_game()
