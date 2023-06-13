extends CanvasLayer
signal on_screen

@onready var hearts: MarginContainer = $Control/MarginContainer/CenterContainer/VBoxContainer/Hearts
@onready var play_button: TextureButton = $Control/MarginContainer/CenterContainer/VBoxContainer/Play
@onready var play_button_label: Label = $Control/MarginContainer/CenterContainer/VBoxContainer/Play/CenterContainer/Label
@onready var info_label: Label = $Control/MarginContainer/CenterContainer/VBoxContainer/InfoLabel
@onready var completion_label: Label = $Control/MarginContainer/CenterContainer/VBoxContainer/CompletionLabel
@onready var buy_heart: TextureButton = $Control/MarginContainer/CenterContainer/VBoxContainer/BuyHeart

func _ready():
	if Memory.hearts == 0:
		play_button.visible = false
		buy_heart.visible = true
		Memory.update_hearts.connect(_on_memory_update_hearts)
	if Memory.challenge_completed:
		play_button_label.text = "Play again"
		info_label.visible = true
		completion_label.visible = true
		hearts.visible = false
	emit_signal("on_screen")
	
func _on_memory_update_hearts(_delta: int):
	var has_hearts: bool = Memory.hearts > 0
	play_button.visible = has_hearts
	buy_heart.visible = not has_hearts

func _on_play_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster, {
		"is_challenge": true,
		"end_challenge_condition": func () -> bool:
			if Constants.combos_strike >= 20:
				return true
			return false
	})
