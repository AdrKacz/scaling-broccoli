extends Node

var mute = false
var sounds = []

func _ready():
	if not OS.has_feature("release"):
		if mute:
			AudioServer.set_bus_mute(0, true)
	sounds.append(preload("res://assets/audio/taunts/taunt1.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt2.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt3.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt4.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt5.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt6.mp3"))

func play_music():
	$BackgroundMusic.play()

func stop_music():
	$BackgroundMusic.stop()

func mute_sounds():
	mute = true

func unmute_sounds():
	mute = false

func play_click():
	print("click sound")
	if not mute:
		$ClickSound.play()

func play_lost():
	if not mute:
		sounds.shuffle()
		$LostSound.stream = sounds.front()
		$LostSound.play()

func play_no_combo():
	if not mute:
		$NoComboSound.play()

func play_change_state():
	if not mute:
		$ChangeStateSound.play()
	
func play_bonus():
	if not mute:
		$BonusSound.play()

func play_action():
	if not mute:
		$ActionSound.play()

func play_shockwave():
	if not mute:
		$ShockwaveSound.play()

func play_clock():
	if not mute and not $ClockSound.playing:
		$ClockSound.play()

func stop_clock():
	$ClockSound.stop()

func play_heartbeat():
	if not mute and not $HeartbeatSound.playing:
		$HeartbeatSound.play()

func stop_heartbeat():
	$HeartbeatSound.stop()

