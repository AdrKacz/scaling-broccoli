extends Node2D

# UNUSED: kept if needed in future version, pulsing heart to see lives remaining
# no more lives in the game

enum Status {
	EMPTY,
	BROKEN,
	FULL,
}

var lost_heart: int = 0
func lose_heart():
	if lost_heart >= get_child_count():
		print('Cannot lose an heart')
		return
	get_child(lost_heart).pulse()
	get_child(lost_heart).frame = Status.EMPTY
	lost_heart += 1
