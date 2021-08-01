extends Node2D

signal score
signal miss
signal wrong


func setup():
	for child in $Games.get_children():
		child.setup()

func change_state(swap):
	for child in $Games.get_children():
		child.change_state()
		
func update_combo_time(new_value, delta):
	for child in $Games.get_children():
		child.update_combo_time(new_value, delta)


func _on_Game_miss():
	emit_signal("miss")


func _on_Game_score():
	emit_signal("score")


func _on_Game_wrong():
	emit_signal("wrong")
