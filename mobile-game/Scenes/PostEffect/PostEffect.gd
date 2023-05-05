extends CanvasLayer

@export var Shockwave: PackedScene

func play_shockwave():
	var shockwave = Shockwave.instantiate()
	add_child(shockwave)

