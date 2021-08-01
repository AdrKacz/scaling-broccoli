extends Node
signal no_time_left

var has_not_time_left = true

const max_wick = 400

var static_time = 0
var animated_time = 0


func _process(delta):
	if (animated_time > 0):
		has_not_time_left = false
		$Sprite/Control.visible = true; 
		
	if has_not_time_left:
		return
#	Update wick
	var interpolation = lerp(0, max_wick, animated_time / Constants.max_combo_time)
	$Sprite/Control/TextureProgressTop.value = interpolation
	$Sprite/Control/TextureProgressRight.value = interpolation
	$Sprite/Control/TextureProgressBottom.value = interpolation
	$Sprite/Control/TextureProgressLeft.value = interpolation
	
#	Update Path
	$Sprite/Path2D/PathFollow2D.unit_offset = clamp(1 -  animated_time / Constants.max_combo_time, 0, 1)
	
#	Check if no time left and emit signal
#	TODO
	if animated_time <= 0:
		emit_signal("no_time_left")
		$Sprite/Control.visible = false;
		has_not_time_left = true
	
func update_time(new_static_time, delta):
#	Tween for interpolation
	print("Update Time from ", static_time, "to ", new_static_time)
	static_time = min(new_static_time, Constants.max_combo_time)
	$Tween.interpolate_property(self, "animated_time", animated_time, static_time, delta)
	if not $Tween.is_active():
		$Tween.start()
	print("Updated static to ", static_time, "and animated to ", animated_time)
	
