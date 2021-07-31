extends Node2D


var new_state = 0



func _ready():
	$Character.set_state($Background.state)
	

func _on_Character_click(state):
	if $Character.state == $Background.state:
		print("  Win")
		$TimeTrial.add_time(1)
	else:
		print("   Wrong")
		$TimeTrial.remove_time(1)
	print("click on state ", state)
	$Character.set_state($Background.state)

# Every background change we check if we miss
func _on_Background_change(old_state):
	print($Background.state, " - ", $Character.state)
	if old_state == $Character.state:
		print("     Miss background ")
		$TimeTrial.remove_time(1)
