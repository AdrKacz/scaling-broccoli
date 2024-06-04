extends Sprite2D

func _ready():
	$CenterContainer/Label.text = 'Level ' + str(Memory.stage)
	Memory.update_stage.connect(_on_memory_update_stage)

func _on_memory_update_stage(stage: int):
	$CenterContainer/Label.text = "Level " + str(stage)
	_pulse()

func _pulse():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("pulse")
