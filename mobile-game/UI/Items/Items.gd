extends CanvasLayer

@onready var quantity_label: Label = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Quantity
@onready var minus_button: Button = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MinusAspectRatioContainer/MinusButton
@onready var plus_button: Button = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PlusAspectRatioContainer/PlusButton
@onready var confirm_button: Button = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ConfirmButton
@onready var hammer_button: TextureButton = $MarginContainer/MarginContainer/VBoxContainer/HammerTextureButton

@onready var hammer_label: Label = $MarginContainer/MarginContainer/VBoxContainer/HammerTextureButton/InStock/MarginContainer/Label
@onready var hammer_extra_1: MarginContainer = $MarginContainer/MarginContainer/VBoxContainer/HammerTextureButton/ExtraHammers/Extra1
@onready var hammer_extra_2: MarginContainer = $MarginContainer/MarginContainer/VBoxContainer/HammerTextureButton/ExtraHammers/Extra2

var quantity: int = 1:
	get:
		return quantity
	set(value):
		quantity = clamp(value, 0, 3)
		quantity_label.text = str(quantity)
		confirm_button.text = "Confirm (x" + str(pow(2, Memory.active_hammers + quantity)) + ')'
		if quantity == 0:
			minus_button.visible = false
		else:
			minus_button.visible = true
		if quantity >= min(3, Memory.hammers) or Memory.active_hammers + quantity >= 3:
			plus_button.visible = false
		else:
			plus_button.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$HammerControl.visible = false
	
	_on_Memory_update_active_hammers(Memory.active_hammers)
	Memory.update_active_hammers.connect(_on_Memory_update_active_hammers)
	
	_on_Memory_update_hammers(Memory.hammers)
	Memory.update_hammers.connect(_on_Memory_update_hammers)
	
func _on_Memory_update_active_hammers(value: int):
	if value == 0:
		hammer_button.self_modulate = Color(Color.WHITE, 0.5)
	else:
		hammer_button.self_modulate = Color.WHITE
	hammer_extra_1.visible = value > 1
	hammer_extra_2.visible = value > 2
	
func _on_Memory_update_hammers(value: int):
	if value >= 10:
		hammer_label.text = "9+"
	else:
		hammer_label.text = str(value)

func _on_hammer_texture_button_pressed():
	quantity = min(3 - Memory.active_hammers, Memory.hammers)
	$HammerControl.visible = true

func _on_exit_button_pressed():
	$HammerControl.visible = false

func _on_plus_button_pressed():
	quantity += 1

func _on_minus_button_pressed():
	quantity -= 1

func _on_confirm_button_pressed():
	#TODO: Register confirmation
	$HammerControl.visible = false
	Memory.active_hammers += quantity
	Memory.hammers -= quantity
	
func toggle_game_mode(is_game: bool):
	pass
