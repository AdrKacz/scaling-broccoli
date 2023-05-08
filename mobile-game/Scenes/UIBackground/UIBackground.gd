extends Node2D

signal change_color(color)

@export var UICharacter: PackedScene

var spawner: Area2D
var size: Vector2
const WALL_WIDTH: float = 320
# Called when the node enters the scene tree for the first time.
func _ready():
	# Move walls screen limits
	spawner = $UICharactersSpawner
	size = get_viewport().get_visible_rect().size
	position_walls()
	spawn()
	$SpawnTimer.start()
	
func spawn():
	# Move at random
	spawner.position = Vector2(
		clamp(randi() % int(size.x), int(WALL_WIDTH / 2), int(size.x - WALL_WIDTH / 2)),
		size.y * .3
	)
	
	if (spawner.has_overlapping_bodies()):
		return # already full
	
	var character: RigidBody2D = UICharacter.instantiate()
	character.position = Vector2(spawner.position.x, -WALL_WIDTH)
	character.y_limit = size.y + 2 * WALL_WIDTH
	character.explode.connect(_on_character_explode)
	add_child(character)

func _on_character_explode(color: Color):
	emit_signal("change_color", color)

func position_walls():
	$Walls/UIWallsDown.position = Vector2(
		size.x * .5,
		size.y + WALL_WIDTH
	)
	$Walls/UIWallsLeft.position = Vector2(
		-WALL_WIDTH,
		size.y * .5
	)
	$Walls/UIWallsRight.position = Vector2(
		size.x + WALL_WIDTH,
		size.y * .5
	)
	
	$Walls/UIWallsDown.scale = Vector2(
		ceil(size.x / WALL_WIDTH),
		1
	)
	$Walls/UIWallsLeft.scale = Vector2(
		1,
		ceil(size.y / WALL_WIDTH)
	)
	$Walls/UIWallsRight.scale = Vector2(
		1,
		ceil(size.y / WALL_WIDTH)
	)
	
func _on_spawn_timer_timeout():
	spawn()
