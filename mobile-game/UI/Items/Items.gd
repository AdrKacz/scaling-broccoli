extends CanvasLayer

@onready var quantity_label: Label = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Quantity
@onready var minus_button: Button = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MinusAspectRatioContainer/MinusButton
@onready var plus_button: Button = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PlusAspectRatioContainer/PlusButton
@onready var confirm_button: Button = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ConfirmButton

var quantity: int = 1:
	get:
		return quantity
	set(value):
		quantity = clamp(value, 1, 3)
		quantity_label.text = str(quantity)
		confirm_button.text = "Confirm (x" + str(pow(2, quantity)) + ')'
		if quantity == 1:
			minus_button.visible = false
		else:
			minus_button.visible = true
		if quantity == 3:
			plus_button.visible = false
		else:
			plus_button.visible = true


# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: Set quantity to max(3, available_quantity)
	quantity = 3

func _on_hammer_texture_button_pressed():
	$HammerControl.visible = true

func _on_exit_button_pressed():
	print('EXIT PRESSED')
	$HammerControl.visible = false

func _on_plus_button_pressed():
	quantity += 1

func _on_minus_button_pressed():
	quantity -= 1

func _on_confirm_button_pressed():
	#TODO: Register confirmation
	$HammerControl.visible = false
