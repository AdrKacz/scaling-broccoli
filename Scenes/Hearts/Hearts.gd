extends Node2D

enum Status {
	EMPTY,
	BROKEN,
	FULL,
}

var broken_heart:int = 0
var empty_heart: int = 0

func lose_heart():
	if empty_heart >= get_child_count():
		print('Cannot lose an heart')
		return
	get_child(empty_heart).pulse()
	get_child(empty_heart).frame = Status.EMPTY
	empty_heart += 1
	
func earn_heart():
	if empty_heart <= 0:
		print('Cannot earn an heart')
		return
	empty_heart -= 1
	get_child(empty_heart).pulse()
	get_child(empty_heart).frame = Status.FULL
