extends MarginContainer
# Called when the node enters the scene tree for the first time.

var computed_safe_area: Rect2
var factors: Vector2

func _ready():
	var safe_area = DisplayServer.get_display_safe_area()
	var screen_size = DisplayServer.screen_get_size()
	
	# Base margin 
	var top: int = get_theme_constant("margin_top")
	var left: int = get_theme_constant("margin_left")
	var bottom: int = get_theme_constant("margin_bottom")
	var right: int = get_theme_constant("margin_right")

	var x_factor: float = 1
	var y_factor: float = 1
	if screen_size.x >= safe_area.size.x and screen_size.y >= safe_area.size.y:
		x_factor = size.x / screen_size.x
		y_factor = size.y / screen_size.y

	top = max(top, safe_area.position.y * y_factor)
	left = max(left, safe_area.position.x * x_factor)
	bottom = max(bottom, abs(safe_area.end.y - screen_size.y) * y_factor)
	right = max(right, abs(safe_area.end.x - screen_size.x) * x_factor)
	
	add_theme_constant_override("margin_top", top)
	add_theme_constant_override("margin_left", left)
	add_theme_constant_override("margin_bottom", bottom)
	add_theme_constant_override("margin_right", right)
	
	computed_safe_area = Rect2(
		safe_area.position.x * x_factor,
		safe_area.position.y * y_factor,
		safe_area.size.x * x_factor,
		safe_area.size.y * y_factor,
	)
	factors = Vector2(x_factor, y_factor)
