extends Node2D
signal lost




func _on_Temps_timeout():
	print("LOST")
	$TempsText.text = "PERDU!"
	emit_signal("lost")
