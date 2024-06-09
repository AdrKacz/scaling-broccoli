extends MarginContainer
signal pressed

@export var file_name: String

@onready var star1: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/Star1
@onready var star2: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/Star2
@onready var star3: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/Star3

func get_level(combo_required: int) -> int:
	if combo_required < 5:
		return 1
	elif combo_required < 10:
		return 2
	else:
		return 3

func _ready():
	if not file_name:
		return
	$PanelContainer/TextureButton.texture_normal = load("res://assets/Cards/" + file_name)
	var combo_required: int = int(file_name.get_slice('_', 0))
	var level: int = get_level(combo_required)
	star1.visible = level >= 1
	star2.visible = level >= 2
	star3.visible = level >= 3
	
func _on_texture_button_pressed():
	emit_signal("pressed")
