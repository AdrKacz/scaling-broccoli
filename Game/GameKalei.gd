extends Node2D

signal score
signal miss
signal wrong
signal no_combo_time_left


func setup():
	for child in $Games.get_children():
		child.setup()
		
func update_background_state():
	for child in $Games.get_children():
		child.update_background_state()
		
func update_combo_time(new_value, delta):
	for child in $Games.get_children():
		child.update_combo_time(new_value, delta)


func _on_Game_miss():
	emit_signal("miss")


func _on_Game_score():
	emit_signal("score")


func _on_Game_wrong():
	emit_signal("wrong")


func _on_Game_no_combo_time_left():
	emit_signal("no_combo_time_left") # Only need one of the four
