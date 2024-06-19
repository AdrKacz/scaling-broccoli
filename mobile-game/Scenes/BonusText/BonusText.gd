extends Node2D
class_name BonusText
@export var text = 0

# Use on screen resize
var is_down: int
var delta: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/Label.text = str(text)
	$AnimationPlayer.play("Popup")

func keep_on_screen(): # Debug only, used to generate screenshots
	# We don't have this in _ready to not add unnecessary branches in the core game logic execution
	# Indeed, this will only be executed when generating screenshots
	$AnimationPlayer.stop()
	scale = Vector2(1, 1)
