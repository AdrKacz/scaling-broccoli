extends Control

func _on_ui_background_change_color(color: Color):
	$ColorRect.modulate = color
