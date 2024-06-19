extends Node

@export var debug_configuration: ImageConfiguration

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameUI/IntroductionText.force_enter() # to prevent it from disappearing
	$GameUI.set_immediate_update_stars()
	$SpeedLines.material.set_shader_parameter('speed', 0)
	if debug_configuration:
		load_configuration(debug_configuration)
	
func load_configuration(configuration: ImageConfiguration):
	$GameUI.clean_bonus_text()
	# Load card
	$Game.update_background_image(configuration.card_texture.resource_path)
	var combo_required: int = int(configuration.card_texture.resource_name.get_file().get_slice('_', 0))
	$GameUI.update_stars(Constants.get_card_level(combo_required))
	if configuration.show_unlocked_image:
		# Card unlocked elements
		configuration.is_in_game = false
		$Game.character_visible = false
		$Game.show_background_image()
		$Game.background_abberation = configuration.image_abberation
	else:
		# In-game elements
		$Game.background_state = configuration.background_state
		$Game.character_visible = true
		$Game.character_state = configuration.character_state
		$SpeedLines.level = configuration.speed_lines_level
		$SpeedLines.material.set_shader_parameter('time_seed', configuration.speed_lines_seed)
	# Add-ons
	Memory.hammers = configuration.hammers
	Memory.active_hammers = configuration.active_hammers
	Memory.shields = configuration.shields
	Session.active_shields = configuration.active_shields
	# Hide/Show UI elements
	$GameUI.toggle_game_mode(configuration.is_in_game)
	# Text
	if configuration.display_introduction_text:
		$GameUI.toggle_introduction_text(true)
	else:
		$GameUI.toggle_introduction_text(false)
	if configuration.display_bonus_text:
		$GameUI.display_immediate_bonus_text('x' + str(configuration.bonus_value), configuration.bonus_position == 1, configuration.bonus_position_delta)
