extends Sprite2D

var countdown: int:
	get:
		return int($CenterContainer/Label.text)
	set(value):
		var previous = countdown
		value = max(0, value)
		$CenterContainer/Label.text = str(value)
		
		# Only animate if you cross a 10s, you pulse on 0s, not on 9s or 1s, so you substract/add 1
		var animate: bool
		if previous > countdown:
			@warning_ignore("integer_division")
			animate = abs((previous - 1) / 10 - (value - 1) / 10) > 0
		else:
			@warning_ignore("integer_division")
			animate = abs((previous + 1) / 10 - (value + 1) / 10) > 0
		if animate:
			if $AnimationPlayer.is_playing():
				$AnimationPlayer.stop()
			$AnimationPlayer.play("pulse")
