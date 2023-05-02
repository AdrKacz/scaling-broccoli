extends Control


func spin():
	$LoadingPath/AnimationPlayer.play("spinner")
	
func stop():
	$LoadingPath/AnimationPlayer.stop()
