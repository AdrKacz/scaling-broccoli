extends PanelContainer
signal pressed

var disabled: bool:
	get:
		return $Panel.visible
	set(value):
		$Panel.visible = value

func _on_button_pressed():
	Session.click()
	emit_signal("pressed")
