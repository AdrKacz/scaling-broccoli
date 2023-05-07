extends CanvasLayer

signal on_screen

var allowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

var submit_label: Label
var name_line_edit: LineEdit

func _ready():
	submit_label = $Control/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/SubmitScore/CenterContainer/Label
	name_line_edit = $Control/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/Name
	NetworkManager.connect("leaderboard", Callable(self, "_on_network_manager_leaderboard"))
	NetworkManager.connect("error", Callable(self, "_on_network_manager_error"))
	
	$AnimationPlayer.play('RESET')
	$Control/MarginContainer/MarginContainerScore/Score.text = str(Constants.score)
	appear()

func update_appear_radius(radius: float):
	$Control.material.set_shader_parameter("radius", radius)

var appear_tween: Tween
func appear():
	if appear_tween:
		appear_tween.kill()
	$Control.visible = true
	$Control/BlockTouch.visible = true
	appear_tween = create_tween().bind_node(self).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT_IN)
	appear_tween.tween_method(update_appear_radius, 0., 1., 1.)
	appear_tween.tween_callback($Control/BlockTouch.set_visible.bind(false))
	appear_tween.tween_callback(emit_signal.bind("on_screen"))
	

var tween: Tween
const OFFSET: int = 32
func animate_submit_error(text: String):
	if tween:
		tween.kill() # Abort the previous animation.
	var original_text = name_line_edit.text
	tween = create_tween().bind_node(self).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(name_line_edit.set_text.bind(text))
	tween.tween_property(name_line_edit, "position", Vector2(OFFSET, 0), .1)
	tween.tween_property(name_line_edit, "position", Vector2(-OFFSET, 0), .1)
	tween.tween_property(name_line_edit, "position", Vector2(0, 0), .1)
	tween.tween_callback(name_line_edit.set_text.bind(original_text)).set_delay(.2)

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
	Session.change_node_to(Session.LeaderboardMenu)

func _on_network_manager_error():
	animate_submit_error("Network Error")

func _on_exit_texture_button_pressed():
	Session.click()
	Session.change_node_to(Session.MainMenu)

func _on_replay_pressed():
	Session.click()
	Session.change_node_to(Session.GameMaster)


func _on_name_text_changed(text: String):
	if not text.right(1) in allowed:
		text = text.left(text.length() - 1)
	var caret_column: int = name_line_edit.caret_column
	name_line_edit.set_text(text.left(12).to_lower().capitalize())
	name_line_edit.set_caret_column(caret_column)
