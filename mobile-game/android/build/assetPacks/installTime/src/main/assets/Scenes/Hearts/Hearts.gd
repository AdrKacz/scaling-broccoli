extends MarginContainer

var hearts: Node2D

func _ready():
	hearts = $HeartsControl/Hearts
	for i in Memory.hearts:
		hearts.get_child(i).frame = Status.FULL
	Memory.update_hearts.connect(_on_memory_update_hearts)

enum Status {
	EMPTY,
	BROKEN,
	FULL,
}

func _on_memory_update_hearts(delta: int):
	if delta == 0:
		return # nothing to do
	
	var from_heart: int = min(Memory.hearts - delta, Memory.hearts)
	var to_heart: int = max(Memory.hearts - delta, Memory.hearts)
	var frame = Status.EMPTY if delta < 0 else Status.FULL
	for i in range(from_heart, to_heart):
		hearts.get_child(i).pulse()
		hearts.get_child(i).frame = frame

	if Memory.hearts == Memory.min_hearts:
		pass # no more life
	elif Memory.hearts == Memory.max_hearts:
		pass # full life
