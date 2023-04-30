extends Node

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

var sounds = []

func _ready():
	sounds.append(preload("res://assets/audio/taunts/taunt1.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt2.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt3.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt4.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt5.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt6.mp3"))
	$Music/BackgroundMusic.play()

func play_click():
	$SoundEffects/ClickSound.play()

func play_lost():
	sounds.shuffle()
	$SoundEffects/LostSound.stream = sounds.front()
	$SoundEffects/LostSound.play()

func play_no_combo():
	$SoundEffects/NoComboSound.play()

func play_change_state():
	$SoundEffects/ChangeStateSound.play()
	
func play_bonus():
	$SoundEffects/BonusSound.play()

func play_action():
	$SoundEffects/ActionSound.play()

func play_shockwave():
	$SoundEffects/ShockwaveSound.play()

func play_clock():
	if not $SoundEffects/ClockSound.playing:
		$SoundEffects/ClockSound.play()

func stop_clock():
	$SoundEffects/ClockSound.stop()

func play_heartbeat():
	if not $SoundEffects/HeartbeatSound.playing:
		$SoundEffects/HeartbeatSound.play()

func stop_heartbeat():
	$SoundEffects/HeartbeatSound.stop()

