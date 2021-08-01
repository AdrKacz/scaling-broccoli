extends HBoxContainer


var rank = ""
var player = ""
var score = ""

func _ready():
	$Rank.text = rank
	$Player.text = player
	$Score.text = score
