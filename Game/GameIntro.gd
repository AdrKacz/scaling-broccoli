extends Node2D

signal score

func _ready():
#	Get correct color
	var correct_color = randi() % Constants.StateEnum.size()
	var correct_index = randi() % $Games.get_child_count()
	$Games.get_child(correct_index).update_background_state_to(correct_color)
	$Games.get_child(correct_index).update_character_state_to(correct_color)
	
	for i in 4:
#		Get wrong couple
		if i != correct_index:
			var background_color = randi() % Constants.StateEnum.size()
			var character_color = randi() % Constants.StateEnum.size()
			while character_color == background_color:
				character_color = randi() % Constants.StateEnum.size()
			$Games.get_child(i).update_background_state_to(background_color)
			$Games.get_child(i).update_character_state_to(character_color)

func _on_Game_score():
	emit_signal("score")
