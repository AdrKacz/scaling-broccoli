extends Control

signal on_screen

func _ready():
	emit_signal("on_screen")
	var music_check_box: CheckBox = $MarginContainer/CenterContainer/VBoxContainer/MusicCheckBox
	var sound_effects_check_box: CheckBox = $MarginContainer/CenterContainer/VBoxContainer/SoundEffectCheckBox
	var vibrations_check_box: CheckBox = $MarginContainer/CenterContainer/VBoxContainer/VibrationsCheckBox
	
	music_check_box.set_pressed_no_signal(AudioManager.music_on)
	sound_effects_check_box.set_pressed_no_signal(AudioManager.sound_effects_on)
	vibrations_check_box.set_pressed_no_signal(Session.vibration_on)
	

func _on_exit_button_pressed():
	Session.click()
	Session.change_node_to(Session.MainMenu)

func _on_music_check_box_toggled(button_pressed):
	Session.click()
	AudioManager.music_on = button_pressed

func _on_sound_effect_check_box_toggled(button_pressed):
	Session.click()
	AudioManager.sound_effects_on = button_pressed

func _on_vibration_check_box_toggled(button_pressed):
	Session.click()
	Session.vibration_on = button_pressed
