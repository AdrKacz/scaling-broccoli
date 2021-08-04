extends CanvasLayer


func set_visible_to(value):
	$Control.visible = value

func _on_Continue_pressed():
	SoundManager.play_click()
	Constants.pause = false
	Session.unpause()


func _on_MainMenu_pressed():
	SoundManager.play_click()
	Constants.pause = false
	Session.main_menu()


func _on_Restart_pressed():
	SoundManager.play_click()
	Constants.pause = false
	Session.start_game()


func _on_Sound_pressed():
	SoundManager.mute_sounds()
	$Control/Center/VBox/HBox/Sound.visible = false
	$Control/Center/VBox/HBox/NoSound.visible = true


func _on_NoSound_pressed():
	SoundManager.unmute_sounds()
	$Control/Center/VBox/HBox/Sound.visible = true
	$Control/Center/VBox/HBox/NoSound.visible = false


func _on_Music_pressed():
	SoundManager.stop_music()
	$Control/Center/VBox/HBox/Music.visible = false
	$Control/Center/VBox/HBox/NoMusic.visible = true


func _on_NoMusic_pressed():
	SoundManager.play_music()
	$Control/Center/VBox/HBox/Music.visible = true
	$Control/Center/VBox/HBox/NoMusic.visible = false
