extends Node2D
signal lost

var time = 20
var perdu = false

func add_time(dt):
	time += dt
	$TempsText.text = str(time)
	
func remove_time(dt):
	time -= dt
	$TempsText.text = str(time)

func _on_UpdateUI_timeout():
	time -= 1
	$TempsText.text = str(time)
	
	if time <= 0:
		print("LOST")
		$TempsText.text = "PERDU!"
		Session.lose()
