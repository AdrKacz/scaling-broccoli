extends Control

func _on_ButtonOff_pressed():
#	Turn on
	AudioManager.mute = false
	$MarginContainerOn.visible = true
	$MarginContainerOff.visible = false


func _on_ButtonOn_pressed():
#	Turn off
	AudioManager.mute = true
	$MarginContainerOn.visible = false
	$MarginContainerOff.visible = true

