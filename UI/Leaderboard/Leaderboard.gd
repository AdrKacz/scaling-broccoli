extends ScrollContainer

export (PackedScene) var ScoreEntry

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Wsh mec")
	
	
	for i in range(20):
		var entry = ScoreEntry.instance()
		entry.text = "Player %s" % i
		$VBoxContainer.add_child(entry)

	
	#print(get_node("Label").text) 
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

""""
func _on_Button_pressed():
	print("Oui monsieur")
	
	print(get_node("VBoxContainer/Label").text)
	
	pass # Replace with function body.
"""
