extends Node


const can_be_background_state = true


# ===== ===== =====
enum StateEnum {
	RED,
	GREEN,
	BLUE
}

const State = {
	StateEnum.RED: Color.red,
	StateEnum.GREEN: Color.green,
	StateEnum.BLUE: Color.blue,
}
# ==== ===== =====


func new_state(red_list=[]):
	if red_list.size() >= StateEnum.size():
		print("ERROR, too many states in the red_list Game.gd")
		return null

	var state = randi() % StateEnum.size()
	while state in red_list:
		state = randi() % StateEnum.size()

	return state
