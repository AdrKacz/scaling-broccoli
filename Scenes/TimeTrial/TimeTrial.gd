extends Node
signal lost

const max_wick = 400

var static_time = Constants.max_time
var animated_time = Constants.max_time

var first_quarter = Constants.max_time / 4
var second_quarter = first_quarter * 2
var third_quarter = first_quarter * 3

func add_time(dt):
	update_time(static_time + dt)
	
func remove_time(dt):
	update_time(static_time - dt)
	
func _process(delta):
#	Update wick
	var interpolation = lerp(0, max_wick, animated_time / Constants.max_time)
	$Control/TextureProgressUp.value = interpolation
	$Control/TextureProgressRight.value = interpolation
	$Control/TextureProgressDown.value = interpolation
	$Control/TextureProgressLeft.value = interpolation
	
#	Check if no time left and emit signal
#	TODO
	if animated_time <= 0:
		print("... No time left")
		Session.lose()
	
func update_time(new_static_time):
#	Tween for interpolation
	static_time = min(new_static_time, Constants.max_time)
	$Tween.interpolate_property(self, "animated_time", animated_time, static_time, $UpdateUI.wait_time)
	if not $Tween.is_active():
		$Tween.start()
	

func _on_UpdateUI_timeout():
	print("... Timeout")
	update_time(static_time - $UpdateUI.wait_time)
	
