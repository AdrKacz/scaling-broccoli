extends MarginContainer
signal pressed

@export var stage: int = 1

func _ready():
	$PanelContainer/TextureButton.texture_normal = load("res://assets/Cards/Level_" + str(stage) + ".jpeg")

func _on_texture_button_pressed():
	emit_signal("pressed")
