extends CanvasLayer

signal on_screen

var allowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

var submit_label: Label
var name_line_edit: LineEdit
var mobile_keyboard_height: float

func get_mobile_keyboard_height_from_memory() -> float:
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	# try to guess the heigh of the virtual keyboard
	var default_height = $Control/MarginContainer.computed_safe_area.size.y * .3	
	if err != OK:
		return default_height
	else:
		return config.get_value('config', 'mobile_keyboard_height', default_height)

func save_mobile_keyboard_height_to_memory():
	var config = ConfigFile.new()
	config.set_value('config', 'mobile_keyboard_height', mobile_keyboard_height)
	config.save("user://config.cfg")

func _ready():
	mobile_keyboard_height = get_mobile_keyboard_height_from_memory()
	
	submit_label = $Control/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/SubmitScore/CenterContainer/Label
	name_line_edit = $Control/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/Name
	NetworkManager.connect("leaderboard", Callable(self, "_on_network_manager_leaderboard"))
	NetworkManager.connect("error", Callable(self, "_on_network_manager_error"))
	
	$AnimationPlayer.play('RESET')
	$Control/MarginContainer/MarginContainerScore/Score.text = str(Constants.score)
	appear()
	
func _process(_delta):
	if not DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
		return
	var height: int = DisplayServer.virtual_keyboard_get_height() * $Control/MarginContainer.factors.y
	if height > 0 and height != mobile_keyboard_height:
		mobile_keyboard_height = height
		save_mobile_keyboard_height_to_memory()
		move_screen_up(
			mobile_keyboard_height,
			.2)

func update_appear_radius(radius: float):
	$Control.material.set_shader_parameter("radius", radius)
	$UIBackground.material.set_shader_parameter("radius", radius)

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
	

var submit_error_tween: Tween
const OFFSET: int = 32
func animate_submit_error(text: String):
	if submit_error_tween:
		submit_error_tween.kill() # Abort the previous animation.
	var original_text = name_line_edit.text
	submit_error_tween = create_tween().bind_node(self).set_ease(Tween.EASE_IN_OUT)
	submit_error_tween.tween_callback(name_line_edit.set_text.bind(text))
	submit_error_tween.tween_property(name_line_edit, "position", Vector2(OFFSET, 0), .1)
	submit_error_tween.tween_property(name_line_edit, "position", Vector2(-OFFSET, 0), .1)
	submit_error_tween.tween_property(name_line_edit, "position", Vector2(0, 0), .1)
	submit_error_tween.tween_callback(name_line_edit.set_text.bind(original_text)).set_delay(.2)

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


func _on_name_text_submitted(_new_text):
	name_line_edit.release_focus()

func _on_name_focus_entered():
	move_screen_up(mobile_keyboard_height, .2)

func _on_name_focus_exited():
	move_screen_up(0, .2)
	
var move_screen_up_tween: Tween
func move_screen_up(up_offset: float, delta: float):
	if move_screen_up_tween:
		move_screen_up_tween.kill()
	move_screen_up_tween = create_tween().bind_node(self)
	move_screen_up_tween.tween_property(self, "offset", Vector2(0, -up_offset), delta)
