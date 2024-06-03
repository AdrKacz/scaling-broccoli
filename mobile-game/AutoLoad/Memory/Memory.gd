extends Node

var config: ConfigFile

func _ready():
	config = ConfigFile.new()
	var err = config.load("user://memory.cfg")
	if err != OK: # never played and file doesn't exit
		stage = 1
	else:
		stage = config.get_value('memory', 'stage', 1)
	stage = 1
	
var stage: int:
	get:
		return stage
	set(value):
		stage = max(0, value)
		config.set_value('memory', 'stage', stage)
		config.save("user://memory.cfg")
