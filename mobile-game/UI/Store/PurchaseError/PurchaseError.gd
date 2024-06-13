extends PanelContainer
signal retry


var items: String:
	get:
		return $VBoxContainer/HBoxContainer/Items.text
	set(value):
		$VBoxContainer/HBoxContainer/Items.text = value

func _on_button_pressed():
	Session.click()
	emit_signal("retry")
