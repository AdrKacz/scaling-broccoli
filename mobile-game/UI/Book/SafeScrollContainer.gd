extends ScrollContainer
# Called when the node enters the scene tree for the first time.

var computed_safe_area: Rect2
var factors: Vector2

func _ready():
	var safe_area = DisplayServer.get_display_safe_area()
	var screen_size = DisplayServer.screen_get_size()
	
	# Base margin 
	var panel: StyleBox = get_theme_stylebox("panel")
	var top: float = panel.get_margin(SIDE_TOP)
	var left: float = panel.get_margin(SIDE_LEFT)
	var bottom: float = panel.get_margin(SIDE_BOTTOM)
	var right: float = panel.get_margin(SIDE_RIGHT)

	var x_factor: float = 1
	var y_factor: float = 1
	if screen_size.x >= safe_area.size.x and screen_size.y >= safe_area.size.y:
		x_factor = size.x / screen_size.x
		y_factor = size.y / screen_size.y

	top = max(top, safe_area.position.y * y_factor)
	left = max(left, safe_area.position.x * x_factor)
	bottom = max(bottom, abs(safe_area.end.y - screen_size.y) * y_factor)
	right = max(right, abs(safe_area.end.x - screen_size.x) * x_factor)
	
	panel.set_content_margin(SIDE_TOP, top)
	panel.set_content_margin(SIDE_LEFT, left)
	panel.set_content_margin(SIDE_BOTTOM, bottom)
	panel.set_content_margin(SIDE_RIGHT, right)
	add_theme_stylebox_override("panel", panel)
	
	computed_safe_area = Rect2(
		safe_area.position.x * x_factor,
		safe_area.position.y * y_factor,
		safe_area.size.x * x_factor,
		safe_area.size.y * y_factor,
	)
	factors = Vector2(x_factor, y_factor)
