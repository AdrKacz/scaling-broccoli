extends CanvasLayer
signal shield_submitted(use_shield: bool)

@onready var quantity_label: Label = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Quantity
@onready var minus_button: Button = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MinusAspectRatioContainer/MinusButton
@onready var plus_button: Button = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PlusAspectRatioContainer/PlusButton
@onready var confirm_button: Button = $HammerControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ConfirmButton

@onready var hammer_button: TextureButton = $MarginContainer/MarginContainer/VBoxContainer/HammerTextureButton
@onready var hammer_label: Label = $MarginContainer/MarginContainer/VBoxContainer/HammerTextureButton/InStock/MarginContainer/Label
@onready var hammer_extra_1: MarginContainer = $MarginContainer/MarginContainer/VBoxContainer/HammerTextureButton/ExtraHammers/Extra1
@onready var hammer_extra_2: MarginContainer = $MarginContainer/MarginContainer/VBoxContainer/HammerTextureButton/ExtraHammers/Extra2

@onready var shield_button: ShieldButton = $MarginContainer/MarginContainer/VBoxContainer/ShieldButton
@onready var shield_label: Label = $MarginContainer/MarginContainer/VBoxContainer/ShieldButton/InStock/MarginContainer/Label
@onready var shield_extra_1: MarginContainer = $MarginContainer/MarginContainer/VBoxContainer/ShieldButton/ExtraShields/Extra1
@onready var shield_extra_2: MarginContainer = $MarginContainer/MarginContainer/VBoxContainer/ShieldButton/ExtraShields/Extra2
@onready var shield_note: Label = $ShieldControl/MarginContainer/CenterContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Note

var shield_control_skip_next_click: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$HammerControl.visible = false
	
	_on_Memory_update_active_hammers(Memory.active_hammers)
	Memory.update_active_hammers.connect(_on_Memory_update_active_hammers)
	_on_Memory_update_hammers(Memory.hammers)
	Memory.update_hammers.connect(_on_Memory_update_hammers)
	
	_on_Memory_update_shields(Memory.shields)
	Memory.update_shields.connect(_on_Memory_update_shields)
	# active_shields is stored in Session and not Memory because it doesn't need to be saved
	# It is only valid for the current Session and will be re-init at each new Session
	_on_Session_update_active_shields(Session.active_shields)
	Session.update_active_shields.connect(_on_Session_update_active_shields)

func toggle_game_mode(_is_game: bool):
	hammer_label.visible = not _is_game
	shield_label.visible = not _is_game

# ===== ===== ===== 
# HAMMERS
# ===== ===== ===== 
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

func _on_Memory_update_active_hammers(value: int):
	hammer_button.self_modulate.a = 1.0 - 0.5 * float(0 == 0)
	hammer_extra_1.visible = value > 1
	hammer_extra_2.visible = value > 2
	
func _on_Memory_update_hammers(value: int):
	if value >= 10:
		hammer_label.text = "9+"
	else:
		hammer_label.text = str(value)

func _on_hammer_texture_button_pressed():
	Session.click()
	quantity = min(3 - Memory.active_hammers, Memory.hammers)
	$HammerControl.visible = true

func _on_exit_button_pressed():
	$HammerControl.visible = false

func _on_plus_button_pressed():
	Session.click()
	quantity += 1

func _on_minus_button_pressed():
	Session.click()
	quantity -= 1

func _on_confirm_button_pressed():
	Session.click()
	$HammerControl.visible = false
	Memory.active_hammers += quantity
	Memory.hammers -= quantity
	
# ===== ===== ===== 
# SHIELD
# ===== ===== =====
func show_shield_contol(within_tap: bool):
	if within_tap:
		# Activated during a tap, we need to unvalid the next click (because it's just the player removing its finger, not an actual click)
		shield_control_skip_next_click = true
	shield_note.visible = Memory.active_hammers > 0
	if Memory.active_hammers > 1:
		shield_note.text = "You will lose your %d activated hammers if you quit" % [Memory.active_hammers]
	else:
		shield_note.text = "You will lose your activated hammer if you quit"
	$ShieldControl.visible = true

func _on_Memory_update_shields(value: int):
	if value >= 10:
		shield_label.text = "9+"
	else:
		shield_label.text = str(value)

func _on_Session_update_active_shields(value: int):
	shield_button.inactive = value == 0
	shield_extra_1.visible = value > 1
	shield_extra_2.visible = value > 2

func _on_yes_shield_button_pressed():
	if shield_control_skip_next_click:
		shield_control_skip_next_click = false
		return
	Session.click()
	$ShieldControl.visible = false
	emit_signal("shield_submitted", true)

func _on_no_shield_button_pressed():
	if shield_control_skip_next_click:
		shield_control_skip_next_click = false
		return
	Session.click()
	$ShieldControl.visible = false
	emit_signal("shield_submitted", false)

func _on_exit_shield_button_pressed():
	if shield_control_skip_next_click:
		shield_control_skip_next_click = false
		return
	$ShieldControl.visible = false
	emit_signal("shield_submitted", false)
