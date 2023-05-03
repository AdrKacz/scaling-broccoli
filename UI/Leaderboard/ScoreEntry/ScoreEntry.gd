extends MarginContainer

@export var rank_string: String
@export var player: String
@export var score: int

func _ready():
	$HBoxContainer/Rank.text = rank_string
	$HBoxContainer/Player.text = player
	$HBoxContainer/Score.text = str(score)
