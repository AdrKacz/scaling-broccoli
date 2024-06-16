extends CanvasLayer
signal exit

func _ready():
	var music_check_box: CheckBox = $Control/MarginContainer/CenterContainer/VBoxContainer/MusicCheckBox
	var sound_effects_check_box: CheckBox = $Control/MarginContainer/CenterContainer/VBoxContainer/SoundEffectCheckBox
	var vibrations_check_box: CheckBox = $Control/MarginContainer/CenterContainer/VBoxContainer/VibrationsCheckBox
	var countdown_check_box: CheckBox = $Control/MarginContainer/CenterContainer/VBoxContainer/CountdownCheckBox
	
	music_check_box.set_pressed_no_signal(AudioManager.music_on)
	sound_effects_check_box.set_pressed_no_signal(AudioManager.sound_effects_on)
	vibrations_check_box.set_pressed_no_signal(Session.vibration_on)
	countdown_check_box.set_pressed_no_signal(Session.show_countdown)

func _on_music_check_box_toggled(button_pressed):
	Session.click()
	AudioManager.music_on = button_pressed

func _on_sound_effect_check_box_toggled(button_pressed):
	Session.click()
	AudioManager.sound_effects_on = button_pressed

func _on_vibration_check_box_toggled(button_pressed):
	Session.click()
	Session.vibration_on = button_pressed

func _on_exit_clicked():
	emit_signal("exit")

func _on_countdown_check_box_toggled(toggled_on):
	Session.click()
	Session.show_countdown = toggled_on
