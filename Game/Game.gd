extends Node2D
export (PackedScene) var ComboScene

var combo = 0
var combo_list = []
var score = 0

func _ready():
	$Background.change_state(0)
	$Character.set_state(1)
	
# Every time the player clicks we check
func _on_Character_click(state):
	# He won
	if $Character.state == $Background.state:
		score += 1 * max(1, combo)
		print("SCORE : ", score)
		$TimeTrial.add_time(1 * combo)
		add_combo()
		$ChangeState.stop()
		$ChangeState.start()
		var new_background_state = Constants.new_state([$Background.state])
		$Background.change_state(new_background_state)
		$Character.set_state(new_background_state)
	
	# He lost
	else:
		$Character.wrong_color()
		reset_combo()
		
	# Reset character's state that isn't the background value
	print("Click on state ", state)
	

# Every background change we check if we miss
func _on_ChangeState_timeout():
	if $Background.state == $Character.state:
		print("     Miss background ")
		reset_combo()
	var new_background_state = Constants.new_state([$Background.state])
	$Background.change_state(new_background_state)

func reset_combo():
	$TimeTrial.remove_time(1)
	get_tree().call_group("combo", "queue_free")
	combo = 0

func add_combo():
	combo += 1
	if combo >= 2:
		var comb = ComboScene.instance()
		comb.multiplier = combo
		var x = randi() % int($Corner.position.x)
		var y = randi() % int($Corner.position.y)
		comb.position = Vector2(x, y)
		add_child(comb)

