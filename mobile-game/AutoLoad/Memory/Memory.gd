extends Node
signal update_stage(value: int)

signal update_hammers(value: int)
signal update_active_hammers(value: int)
signal update_unlocked_cards(value: int)

var config: ConfigFile
func _ready():
	config = ConfigFile.new()
	var err = config.load("user://memory.cfg")
	if err != OK: # never played and file doesn't exit
		hammers = 0
		active_hammers = 0
		reset_unlocked_cards()
	# DEBUG
	hammers = 10
	active_hammers = 0
	# reset_unlocked_cards()
	
var hammers: int:
	get:
		return config.get_value('memory', 'hammers', 0)
	set(value):
		value = max(0, value)
		config.set_value('memory', 'hammers', value)
		config.save("user://memory.cfg")
		emit_signal("update_hammers", value)
		
var active_hammers: int:
	get:
		return config.get_value('memory', 'active_hammers', 0)
	set(value):
		value = clamp(value, 0, 3)
		config.set_value('memory', 'active_hammers', value)
		config.save("user://memory.cfg")
		emit_signal("update_active_hammers", value)

# TODO: As the number of cards scale, it would be more efficient using a Set instead
func get_unlocked_cards() -> Array[String]:
	var unlocked_cards: Array[Variant] = config.get_value('memory', 'unlocked_cards', [])
	var converted_unlocked_cards: Array[String]
	converted_unlocked_cards.assign(unlocked_cards)
	return converted_unlocked_cards

func unlock_card(card: String) -> void:
	var unlocked_cards: Array[String] = get_unlocked_cards()
	unlocked_cards.append(card)
	config.set_value('memory', 'unlocked_cards', unlocked_cards)
	config.save("user://memory.cfg")
	emit_signal("update_unlocked_cards", unlocked_cards)

func reset_unlocked_cards() -> void:
	config.set_value('memory', 'unlocked_cards', [])
	config.save("user://memory.cfg")
	emit_signal("update_unlocked_cards", [])
