extends Control

@export var scrolling_mode: bool = false

func _ready():
	if scrolling_mode:
		$UIBackground/Walls/UIWallsDown/CollisionShape2D.disabled = true
		$UIBackground/Walls/UIWallsLeft/CollisionShape2D.disabled = true
		$UIBackground/Walls/UIWallsRight/CollisionShape2D.disabled = true

func _on_ui_background_change_color(color: Color):
	$ColorRect.modulate = color
