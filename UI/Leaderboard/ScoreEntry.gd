extends MarginContainer


var rank = ""
var player = ""
var score = ""

func _ready():
	$HBoxContainer/Rank.text = rank
	$HBoxContainer/Player.text = player
	$HBoxContainer/Score.text = score
