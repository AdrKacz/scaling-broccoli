extends Node

@export var BonusText: PackedScene
@export var CountDown: PackedScene

func _ready():
	$Game/Game.setup()

func score():
	print('You scored!')
	if randf() <= 0.3:
		# Note: (old) was changing mode here one every three success (from 1 tile to 4 tiles)
		$PostEffect.play_shockwave(Constants.shockwave_force_strong, Constants.shockwave_thickness_strong)
	else:
		$PostEffect.play_shockwave()

func wrong():
	print("You missed!")
	Constants.lives -= 1
	if Constants.lives == 0:
		# TODO: lose is a bit straighforward, a little animation won't hurt
		Session.lose()

func display(text, position_base):
	var bonus_text = BonusText.instantiate()
	bonus_text.text = text
	bonus_text.position = position_base + Vector2(randf_range(-64, 64), randf_range(-64, 64)) # randomise
	add_child(bonus_text)

func _on_Pause_pressed():
	Constants.pause = true
	Session.pause_with_opacity()
