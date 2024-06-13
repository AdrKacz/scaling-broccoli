extends PanelContainer


var items: String:
	get:
		return $VBoxContainer/HBoxContainer/Items.text
	set(value):
		$VBoxContainer/HBoxContainer/Items.text = value
