extends Sprite2D

var countdown: int:
	get:
		return int($CenterContainer/Label.text)
	set(value):
		var previous = countdown
		value = max(0, value)
		$CenterContainer/Label.text = str(value)
		if abs((previous - 1) / 10 - (value - 1) / 10) > 0:
			# Only animate if you cross a 10s, you pulse on 0s, not on 9s, so you substract 1
			if $AnimationPlayer.is_playing():
				$AnimationPlayer.stop()
			$AnimationPlayer.play("pulse")
