extends Node


export (String, FILE, "*.tscn") var game_path = "res://Game/Game.tscn"
export (PackedScene) var PauseMenu

onready var root = get_tree().get_root()


	
func options_with_opacity():
	get_tree().paused = true
	var pause_menu = PauseMenu.instance()
	pause_menu.set_opacity()
	root.get_child(root.get_child_count() - 1).add_child(pause_menu)

func start():
	get_tree().change_scene(game_path)
	
func restart_game():
	get_tree().change_scene(game_path)
	
