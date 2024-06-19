extends Node

@export var card_texture: Texture2D
@export var is_in_game: bool
@export var show_unlocked_image: bool # if true, is_in_game switch automatically to false
@export_group("In Game")
@export var background_state: Constants.StateEnum
@export var character_state: Constants.StateEnum
@export var display_introduction_text: bool
@export_subgroup("Bonus")
@export var display_bonus_text: bool
@export_range(1, 999) var bonus_value: int
@export_subgroup("Speed Lines")
@export_range(-1, 2) var speed_lines_level: int # 2 is MAX_LEVELS in SpeedLines.gd
@export var speed_lines_seed: float = 28.22 # Speed lines are static in this mode, change how they look by changing the seed
@export_group("Unlocked image")
@export_range(0, 0.1) var image_abberation: float
@export_group("Add-ons")
@export var hammers: int
@export_range(0, 3) var active_hammers: int
@export var shields: int
@export_range(0, 3) var active_shields: int

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load card
	$Game.update_background_image(card_texture.resource_path)
	var combo_required: int = int(card_texture.resource_name.get_file().get_slice('_', 0))
	$GameUI.set_immediate_update_stars()
	$GameUI.update_stars(Constants.get_card_level(combo_required))
	if show_unlocked_image:
		# Card unlocked elements
		is_in_game = false
		$Game.character_visible = false
		$Game.show_background_image()
		$Game.background_abberation = image_abberation
	else:
		# In-game elements
		$Game.background_state = background_state
		$Game.character_visible = true
		$Game.character_state = character_state
		$SpeedLines.level = speed_lines_level
		$SpeedLines.material.set_shader_parameter('time_seed', speed_lines_seed)
		$SpeedLines.material.set_shader_parameter('speed', 0)
	# Add-ons
	Memory.hammers = hammers
	Memory.active_hammers = active_hammers
	Memory.shields = shields
	Session.active_shields = active_shields
	# Hide/Show UI elements
	$GameUI.toggle_game_mode(is_in_game)
	# Text
	if display_introduction_text:
		$GameUI/IntroductionText.force_enter()
	else:
		$GameUI.remove_introduction_text()
	if display_bonus_text:
		$GameUI.display_immediate_bonus_text('x' + str(bonus_value))
		
