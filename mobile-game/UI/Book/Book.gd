extends CanvasLayer
signal exit

@export var Card: PackedScene
@export var LockedCard: PackedScene

const CARDS_FOLDER: String = "res://assets/Cards" 

func _on_exit_texture_button_pressed():
	emit_signal("exit")

func _on_card_pressed(file_name: String):
	$CardFullScreen.texture_normal = load(CARDS_FOLDER + "/" + file_name)
	$CardFullScreen.visible = true

func _on_card_full_screen_pressed():
	$CardFullScreen.visible = false
	

func dir_contents(path):
	var dir = DirAccess.open(path)
	var file_names: Array[String] = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not (dir.current_is_dir() or file_name.contains('.import')):
				file_names.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.") 
	file_names.sort_custom(func(a, b): return a.naturalnocasecmp_to(b) < 0)
	return file_names

func _on_visibility_changed():
	if not visible:
		return
	# Clean up current state
	var flow_container: HFlowContainer = $Control/ScrollContainer/HFlowContainer
	for n in flow_container.get_children():
		flow_container.remove_child(n)
		n.queue_free()
		
	# TODO: we want to cache the results to not re-initiate all cards everytime
	# Fine for now, we have just 20 cards
	var unlocked_cards: Array[Node] = []
	var locked_cards: Array[Node] = []  
	for file_name in dir_contents(CARDS_FOLDER):
		if file_name in Memory.get_unlocked_cards():
			var card = Card.instantiate()
			card.file_name = file_name
			card.pressed.connect(_on_card_pressed.bind(file_name))
			unlocked_cards.append(card)
			
		else:
			var card = LockedCard.instantiate()
			locked_cards.append(card)
	# Display unlocked one first
	for card in unlocked_cards:
		flow_container.add_child(card)
	for card in locked_cards:
		flow_container.add_child(card)
