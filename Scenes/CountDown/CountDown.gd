extends Sprite

signal end_count_down

func end_of_counter():
	emit_signal("end_count_down")
	
func _ready():
	$AnimationPlayer.play("Popup")
