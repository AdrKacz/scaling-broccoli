extends Node2D
export var multiplier = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ComboText.text = "X " + str(multiplier)
	$AnimationPlayer.play("Popup")
	$ComboSound.play()

		
