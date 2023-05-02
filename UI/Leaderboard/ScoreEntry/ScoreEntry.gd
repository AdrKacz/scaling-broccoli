extends MarginContainer

@export var rank: int
@export var player: String
@export var score: int

func _ready():
	$HBoxContainer/Rank.text = str(rank)
	$HBoxContainer/Player.text = player
	$HBoxContainer/Score.text = str(score)
