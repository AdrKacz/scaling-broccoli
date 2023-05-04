extends Control

func _ready():
	# center character on screen
	$Sprite2D.position = get_parent_area_size() / 2
