extends Node
signal lost

var has_not_time_left = false

const max_wick = 400

var static_time = Constants.maximum_time
var animated_time = Constants.maximum_time

func start_timer():
	$UpdateUI.start()

func add_time(dt):
	update_time(static_time + dt)
	
func remove_time(dt):
	update_time(static_time - dt)
	
func _process(delta):
	if has_not_time_left:
		return
#	Update wick
	var interpolation = lerp(0, max_wick, animated_time / Constants.maximum_time)
	$Control/TextureProgressUp.value = interpolation
	$Control/TextureProgressRight.value = interpolation
	$Control/TextureProgressDown.value = interpolation
	$Control/TextureProgressLeft.value = interpolation
	
#	Update Path
	$Path2D/PathFollow2D.unit_offset = clamp(1 -  animated_time / Constants.maximum_time, 0, 1)
	if $Path2D/PathFollow2D.unit_offset >= 0.8 and not $ClockSound.playing:
		$ClockSound.play()
	if $Path2D/PathFollow2D.unit_offset >= 0.9 and not $HeartbeatSound.playing:
		$HeartbeatSound.play()
#	Check if no time left and emit signal
#	TODO
	if animated_time <= 0:
		emit_signal("lost")
		$UpdateUI.stop()
		has_not_time_left = true
	
func update_time(new_static_time):
#	Tween for interpolation
	static_time = min(new_static_time, Constants.maximum_time)
	$Tween.interpolate_property(self, "animated_time", animated_time, static_time, $UpdateUI.wait_time)
	if not $Tween.is_active():
		$Tween.start()
	

func _on_UpdateUI_timeout():
	update_time(static_time - $UpdateUI.wait_time)
	
