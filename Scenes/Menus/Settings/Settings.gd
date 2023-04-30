extends Control

func _on_exit_button_pressed():
	Session.main_menu()

func _on_music_check_box_toggled(button_pressed):
	# TODO: have only music
	SoundManager.music_on = button_pressed

func _on_sound_effect_check_box_toggled(button_pressed):
	# TODO: have only sound effect
	SoundManager.sound_effects_on = button_pressed

func _on_vibration_check_box_toggled(button_pressed):
	Session.vibration_on = button_pressed
