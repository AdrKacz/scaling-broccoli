extends CanvasLayer

signal on_screen

@export var is_challenge: bool = false
@export var challenge: Dictionary

func _ready():
	Constants.score = 0
	Constants.combos_strike = 0
	appear()
	
func update_appear_radius(radius: float):
	$Control.material.set_shader_parameter("radius", radius)

var tween: Tween
func appear():
	if tween:
		tween.kill()
	tween = create_tween().bind_node(self).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT_IN)
	tween.tween_method(update_appear_radius, 0., 1., 1.)
	tween.tween_callback(emit_signal.bind("on_screen"))

func increment_combos_strike():
	Constants.combos_strike += 1
	
	if Constants.combos_strike >= 2:
		@warning_ignore("integer_division")
		$Control/SpeedLines.level = int(Constants.combos_strike / 10)
		$Control/GameUI.display_bonus_text('x' + str(Constants.combos_strike))
	
func reset_combos_strike():
	$Control/SpeedLines.level = -1
	Constants.combos_strike = 0
	
func _on_game_miss():
	reset_combos_strike()
	challenge_action('miss')

func _on_game_score() -> void:
	increment_combos_strike()
	Constants.score += Constants.score_factor * Constants.combos_strike
	$Control/GameUI.update_score(Constants.score)
	challenge_action('score')
	
func _on_game_wrong():
	reset_combos_strike()
	if is_challenge == true:
		Session.change_node_to(Session.LoseChallenge)
	else:
		Session.change_node_to(Session.LoseMenu)
		
func challenge_action(action: String) -> void:
	if is_challenge and challenge.has(action):
		var state: Challenges.States = challenge[action].call()
		match state:
			Challenges.States.WIN:
				Session.change_node_to(Session.WinChallenge)
			Challenges.States.LOSE:
				Session.change_node_to(Session.LoseChallenge)


func _on_game_skip():
	challenge_action('skip')
