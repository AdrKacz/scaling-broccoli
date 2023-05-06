extends CanvasLayer

var allowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "

var submit_label: Label
var name_line_edit: LineEdit

func _ready():
	submit_label = $Control/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/SubmitScore/CenterContainer/Label
	name_line_edit = $Control/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/Name
	NetworkManager.connect("leaderboard", Callable(self, "_on_network_manager_leaderboard"))
	NetworkManager.connect("error", Callable(self, "_on_network_manager_error"))

func set_visible_to(value):
	$AnimationPlayer.play('RESET')
	$Control/MarginContainer/MarginContainerScore/Score.text = str(Constants.score)
	$Control.visible = value

var tween: Tween
const OFFSET: int = 32
func animate_submit_error(text: String):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween().bind_node(self).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(submit_label, "text", text, .0)
	tween.tween_property(name_line_edit, "position", Vector2(OFFSET, 0), .1)
	tween.tween_property(name_line_edit, "position", Vector2(-OFFSET, 0), .1)
	tween.tween_property(name_line_edit, "position", Vector2(0, 0), .1)
	tween.tween_callback($AnimationPlayer.play.bind('RESET')).set_delay(.7)

func _on_SubmitScore_pressed():
	Session.click()
	var player_name = name_line_edit.text
	var errorMessage = ""
	for letter in player_name:
		if not letter in allowed: # TODO Hello Regex	
			errorMessage = "Not valid"		
	if player_name.length() < 3:
		errorMessage = "Too short"
	
	if errorMessage.length() > 0:
		animate_submit_error(errorMessage)
	else:
		NetworkManager.post_leaderboard(player_name, Constants.score)
		$AnimationPlayer.play("wait_submit")
		
func _on_network_manager_leaderboard(leaders, player_position):
	Session.in_memory_leaderboard = {
		"leaders": leaders,
		"position": player_position
	}
	Session.read_leaderboard_from_memory = true
	Session.leaderboard()

func _on_network_manager_error():
	animate_submit_error("Network Error")

func _on_exit_texture_button_pressed():
	Session.click()
	Session.main_menu()


func _on_restart_button_pressed():
	Session.click()
	Session.start_game()
