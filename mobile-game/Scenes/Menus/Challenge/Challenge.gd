extends CanvasLayer
signal on_screen

var hearts: MarginContainer
var play_button: TextureButton
var play_button_label: Label
var info_label: Label
var completion_label: Label

func _ready():
	hearts = $Control/MarginContainer/CenterContainer/VBoxContainer/Hearts
	play_button = $Control/MarginContainer/CenterContainer/VBoxContainer/Play
	play_button_label = $Control/MarginContainer/CenterContainer/VBoxContainer/Play/CenterContainer/Label
	info_label = $Control/MarginContainer/CenterContainer/VBoxContainer/InfoLabel
	completion_label = $Control/MarginContainer/CenterContainer/VBoxContainer/CompletionLabel
	if Memory.remaining_lives == 0:
		play_button.visible = false
	if Memory.challenge_completed:
		play_button_label.text = "Play again"
		info_label.visible = true
		completion_label.visible = true
		hearts.visible = false
	emit_signal("on_screen")

func _on_exit_button_pressed():
	Session.click()
	Session.change_node_to(Session.MainMenu)

func _on_play_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster, {
		"is_challenge": true,
		"end_challenge_condition": func () -> bool:
			if Constants.combos_strike >= 20:
				return true
			return false
	})
