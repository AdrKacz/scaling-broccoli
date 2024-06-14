extends PanelContainer
signal pressed

@export var product_id: String

var disabled: bool:
	get:
		return $Panel.visible
	set(value):
		$Panel.visible = value

func _on_button_pressed():
	Session.click()
	emit_signal("pressed")
	
func init():
	if not product_id or not product_id in Apple.products:
		visible = false # Hide as it cannot be used without a valid product id
		return
	$HBoxContainer/Price.text = Apple.products[product_id] # Set the localised price
