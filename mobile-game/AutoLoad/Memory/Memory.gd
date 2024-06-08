extends Node
signal update_stage(value: int)

signal update_hammers(value: int)
signal update_active_hammers(value: int)

var config: ConfigFile
func _ready():
	config = ConfigFile.new()
	var err = config.load("user://memory.cfg")
	if err != OK: # never played and file doesn't exit
		stage = 1
		hammers = 0
		active_hammers = 0
	# DEBUG
	stage = 1
	hammers = 10
	active_hammers = 0
	
var stage: int:
	get:
		return config.get_value('memory', 'stage', 1)
	set(value):
		value = max(0, value)
		config.set_value('memory', 'stage', value)
		config.save("user://memory.cfg")
		emit_signal("update_stage", value)

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
