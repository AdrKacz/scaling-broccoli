extends Node2D

signal score
signal miss
signal wrong


func start_game(wait_time):
	for child in $Games.get_children():
		child.start_game(wait_time)


func _on_Game_miss():
	emit_signal("miss")


func _on_Game_score():
	emit_signal("score")


func _on_Game_wrong():
	emit_signal("wrong")
