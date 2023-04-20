extends Node
signal no_time_left

var has_not_time_left = true

const max_wick = 400

var static_time = 0
var animated_time = 0


func _process(delta):
	if (animated_time > 0):
		has_not_time_left = false
		$Sprite2D/Control.visible = true; 
		
	if has_not_time_left:
		return
#	Update wick
	var animated_ratio = 0
	if Constants.combo_time > 0:
		animated_ratio = animated_time / Constants.combo_time
	var interpolation = lerp(0, max_wick, animated_ratio)
		
	$Sprite2D/Control/TextureProgressTop.value = interpolation
	$Sprite2D/Control/TextureProgressRight.value = interpolation
	$Sprite2D/Control/TextureProgressBottom.value = interpolation
	$Sprite2D/Control/TextureProgressLeft.value = interpolation
	
#		Update Path
	$Sprite2D/Path2D/PathFollow2D.progress_ratio = clamp(1 -  animated_ratio, 0, 1)
	
#	Check if no time left and emit signal
#	TODO
	if animated_time <= 0 or Constants.combo_time <= 0:
		emit_signal("no_time_left")
		$Sprite2D/Control.visible = false;
		has_not_time_left = true

func update_time(new_static_time, delta):
#	Tween for interpolation
	static_time = clamp(new_static_time, 0, Constants.combo_time)
	$Tween.interpolate_property(self, "animated_time", animated_time, static_time, delta)
	if not $Tween.is_active():
		$Tween.start()
	
