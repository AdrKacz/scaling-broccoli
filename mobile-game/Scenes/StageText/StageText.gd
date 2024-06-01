extends Sprite2D

var text: String = 'Stage 1':
	get:
		return text
	set(value):
		text = value
		$CenterContainer/Label.text = text

func pulse():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("pulse")
