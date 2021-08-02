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
	var animated_ratio = 0
	if Constants.combo_time > 0:
		animated_ratio = animated_time / Constants.combo_time
	var interpolation = lerp(0, max_wick, animated_ratio)
		
	$Sprite/Control/TextureProgressTop.value = interpolation
	$Sprite/Control/TextureProgressRight.value = interpolation
	$Sprite/Control/TextureProgressBottom.value = interpolation
	$Sprite/Control/TextureProgressLeft.value = interpolation
	
#		Update Path
	$Sprite/Path2D/PathFollow2D.unit_offset = clamp(1 -  animated_ratio, 0, 1)
	
#	Check if no time left and emit signal
#	TODO
	if animated_time <= 0 or Constants.combo_time <= 0:
		emit_signal("no_time_left")
		$Sprite/Control.visible = false;
		has_not_time_left = true

func update_time(new_static_time, delta):
#	Tween for interpolation
	print("Hello with", new_static_time)
	static_time = clamp(new_static_time, 0, Constants.combo_time)
	$Tween.interpolate_property(self, "animated_time", animated_time, static_time, delta)
	if not $Tween.is_active():
		$Tween.start()
	
