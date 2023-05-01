extends Control

func _ready():
	var music_check_box: CheckBox = $MarginContainer/CenterContainer/VBoxContainer/MusicCheckBox
	var sound_effects_check_box: CheckBox = $MarginContainer/CenterContainer/VBoxContainer/SoundEffectCheckBox
	var vibrations_check_box: CheckBox = $MarginContainer/CenterContainer/VBoxContainer/VibrationsCheckBox
	
	music_check_box.set_pressed_no_signal(SoundManager.music_on)
	sound_effects_check_box.set_pressed_no_signal(SoundManager.sound_effects_on)
	vibrations_check_box.set_pressed_no_signal(Session.vibration_on)
	

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
