extends Node

var mute: bool = false:
	get:
		return mute
	set(value):
		mute = value
		AudioServer.set_bus_mute(0, mute)
var sounds = []

func _ready():
	sounds.append(preload("res://assets/audio/taunts/taunt1.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt2.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt3.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt4.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt5.mp3"))
	sounds.append(preload("res://assets/audio/taunts/taunt6.mp3"))
	
	$BackgroundMusic.play()

func play_click():
	print("Click Sound")
	$ClickSound.play()

func play_lost():
	sounds.shuffle()
	$LostSound.stream = sounds.front()
	$LostSound.play()

func play_no_combo():
	$NoComboSound.play()

func play_change_state():
	$ChangeStateSound.play()
	
func play_bonus():
	$BonusSound.play()

func play_action():
	$ActionSound.play()

func play_shockwave():
	$ShockwaveSound.play()

func play_clock():
	if not $ClockSound.playing:
		$ClockSound.play()

func stop_clock():
	$ClockSound.stop()

func play_heartbeat():
	if not $HeartbeatSound.playing:
		$HeartbeatSound.play()

func stop_heartbeat():
	$HeartbeatSound.stop()

