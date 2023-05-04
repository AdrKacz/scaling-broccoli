extends Node

enum SOUND_EFFECTS {
	CLICK,
	TAP
}

var music_on: bool = true:
	get:
		return music_on
	set(value):
		music_on = value
		AudioServer.set_bus_mute(1, not music_on)
		
var sound_effects_on: bool = true:
	get:
		return sound_effects_on
	set(value):
		sound_effects_on = value
		AudioServer.set_bus_mute(2, not sound_effects_on)

func _ready():
	music_on = false

func play_sound_effects(index):
	$SoundEffects.get_child(index).play()
