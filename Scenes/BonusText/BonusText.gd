extends Node2D
export var text = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/Label.text = str(text)
	$AnimationPlayer.play("Popup")
	$BonusSound.play()

	
