extends Node2D
export (PackedScene) var ComboScene

var combo = 0
var combo_list = []

func _ready():
	$Character.set_state($Background.state)
	
# Every time the player clicks we check
func _on_Character_click(state):
	# He won
	if $Character.state == $Background.state:
		print("  Win")
		$TimeTrial.add_time(1 * combo)
		combo += 1
		if combo >= 2:
			var comb = ComboScene.instance()
			comb.multiplier = combo
			add_child(comb)
	
	# He lost
	else:
		print("   Wrong")
		$TimeTrial.remove_time(1)
		get_tree().call_group("combo", "queue_free")
		combo = 0
		
	# Reset character's state that isn't the background value
	print("click on state ", state)
	$Character.set_state($Background.state)

# Every background change we check if we miss
func _on_Background_change(old_state):
	print($Background.state, " - ", $Character.state)
	if old_state == $Character.state:
		print("     Miss background ")
		$TimeTrial.remove_time(1)
		get_tree().call_group("combo", "queue_free")
