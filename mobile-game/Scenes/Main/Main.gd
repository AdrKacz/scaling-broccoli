class_name MainNode
extends Node

var current_node: Node

func _ready():
	Session.assign_main_node(self)
	change_node_to(Session.MainMenu)

func change_node_to(scene: PackedScene, params: Dictionary = {}):
	var node: Node = scene.instantiate()
	node.on_screen.connect(_on_node_on_screen.bind(current_node))
	for key in params:
		var value: Variant = params[key]
		if value != null:
			node[key] = params[key]
	add_child(node)
	current_node = node

func _on_node_on_screen(dead_node: Node):
	if is_instance_valid(dead_node):
		remove_child(dead_node)
		dead_node.queue_free()
