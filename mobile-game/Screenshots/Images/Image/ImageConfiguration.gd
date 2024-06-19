extends Resource
class_name ImageConfiguration

@export var card_texture: Texture2D = null
@export var is_in_game: bool = false
@export_group("In Game")
@export var background_state: Constants.StateEnum = Constants.StateEnum.YELLOW
@export var character_state: Constants.StateEnum = Constants.StateEnum.YELLOW
@export var display_introduction_text: bool = true
@export_subgroup("Bonus")
@export var display_bonus_text: bool = true
@export_range(1, 999) var bonus_value: int = 24
@export_enum("UP", "DOWN") var bonus_position: int = 0
@export var bonus_position_delta: Vector2 = Vector2(24, -43) # Try to keep it between -64, 64
@export_subgroup("Speed Lines")
@export_range(-1, 2) var speed_lines_level: int = 0 # 2 is MAX_LEVELS in SpeedLines.gd
@export var speed_lines_seed: float = 28.22 # Speed lines are static in this mode, change how they look by changing the seed
@export_group("Unlocked image")
@export var show_unlocked_image: bool = false # if true, is_in_game switch automatically to false
@export_range(0, 0.1) var image_abberation: float = 0
@export_group("Add-ons")
@export var hammers: int = 0
@export_range(0, 3) var active_hammers: int = 0
@export var shields: int = 0
@export_range(0, 3) var active_shields: int = 0
