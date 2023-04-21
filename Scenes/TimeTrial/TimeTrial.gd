extends Node
signal lost

var has_not_time_left = false

const max_wick = 400

var static_time: float = Constants.maximum_time
var animated_time: float = Constants.maximum_time

func start_timer():
	$UpdateUI.start()

func add_time(dt):
	update_time(static_time + dt)
	
func remove_time(dt):
	update_time(static_time - dt)
	
func _process(_delta):
	if has_not_time_left:
		return
#	Update wick
	var interpolation = lerp(0, max_wick, animated_time / Constants.maximum_time)
	$Control/TextureProgressUp.value = interpolation
	$Control/TextureProgressRight.value = interpolation
	$Control/TextureProgressDown.value = interpolation
	$Control/TextureProgressLeft.value = interpolation
	
#	Update Path
	$Path2D/PathFollow2D.progress_ratio = clamp(1 -  animated_time / Constants.maximum_time, 0, 1)
	if $Path2D/PathFollow2D.progress_ratio >= 0.8:
		SoundManager.play_clock()
	elif $Path2D/PathFollow2D.progress_ratio >= 0.9:
		SoundManager.play_heartbeat()
		SoundManager.play_clock()
	else:
		SoundManager.stop_clock()
		SoundManager.stop_heartbeat()
#	Check if no time left and emit signal
#	TODO
	if animated_time <= 0:
		emit_signal("lost")
		$UpdateUI.stop()
		has_not_time_left = true
	
func update_time(new_static_time):
#	Tween for interpolation
	static_time = min(new_static_time, Constants.maximum_time)
		
	var tween: Tween = create_tween()
	# TODO: need to check if there is not already an animation here
	tween.tween_property(self, "animated_time", static_time, $UpdateUI.wait_time)
	

func _on_UpdateUI_timeout():
	update_time(static_time - $UpdateUI.wait_time)
	
