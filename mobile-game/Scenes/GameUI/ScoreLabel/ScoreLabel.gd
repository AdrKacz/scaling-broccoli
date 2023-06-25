class_name ScoreLabel
extends Control

@onready var label: Label = $Sprite/Label
@onready var sprite: Sprite2D = $Sprite

func _ready():
	label.text = _get_text(0)
	Constants.update_score.connect(_on_update_score)
	
func _get_text(score: int) -> String:
	var combo_string: String = str(score)
	
	@warning_ignore("integer_division")
	var combo_length_modulo_three: int = floor(combo_string.length() / 3)
	if combo_length_modulo_three > 0:
		var combo_string_array: Array[String] = []
		for i in combo_length_modulo_three:
			combo_string_array.push_front(combo_string.substr(
				combo_string.length() - (i + 1) * 3,
				3
			))
		if combo_string.length() % 3 > 0:
			combo_string_array.push_front(combo_string.substr(0, combo_string.length() % 3))
		return ','.join(combo_string_array)
	else:
		return combo_string

func _on_update_score() -> void:
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("pulse")
	label.text = _get_text(Constants.score)

