extends Sprite2D

func _ready():
	$CenterContainer/Label.text = 'Level ' + str(Memory.stage)

func update():
	$CenterContainer/Label.text = "Level " + str(Memory.stage)
	_pulse()

func _pulse():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("pulse")
