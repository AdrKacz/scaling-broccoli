extends MarginContainer

var hearts: Node2D

func _ready():
	hearts = $HeartsControl/Hearts
	for i in Constants.remaining_lives:
		hearts.get_child(i).frame = Status.FULL

enum Status {
	EMPTY,
	BROKEN,
	FULL,
}

func lose_heart():
	if Constants.remaining_lives == 0:
		return # cannot lose a life
	var heart: AnimatedSprite2D = hearts.get_child(Constants.remaining_lives - 1)
	heart.pulse()
	heart.frame = Status.EMPTY
	Constants.remaining_lives -= 1
	if Constants.remaining_lives == 0:
		pass # no more life
