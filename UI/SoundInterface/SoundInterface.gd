extends Control

func _on_ButtonOff_pressed():
#	Turn on
	SoundManager.play_music()
	SoundManager.unmute_sounds()
	$MarginContainerOn.visible = true
	$MarginContainerOff.visible = false


func _on_ButtonOn_pressed():
#	Turn off
	SoundManager.stop_music()
	SoundManager.mute_sounds()
	$MarginContainerOn.visible = false
	$MarginContainerOff.visible = true

