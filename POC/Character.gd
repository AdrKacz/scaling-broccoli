extends Node2D


# Declare member variables here. Examples:
var time = 0
var new_frame = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$cible.set_global_position(Vector2(800,250))
	$cible.scale = Vector2(10,10)
	$Button.set_global_position(Vector2(400,100))
	$fond.set_global_position(Vector2(300,250))
	$fond.scale = Vector2(10,10)
	$score.set_global_position(Vector2(300,50))
	$score.text = "0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	


func _on_Timer_timeout():
	print("time", time, " frame ", $fond.frame)
	time += 1
	$fond.frame = find_new_frame([$fond.frame])

func find_new_frame(current):
	new_frame = randi() % 4
	while new_frame in current:
		new_frame = randi() % 4
	return new_frame
	


func _on_Button_pressed():
	print("click")
	
	if $fond.frame == $cible.frame:
		$score.text = str(1 + int($score.text))
		$cible.frame = find_new_frame([$fond.frame])
		$fond.frame = find_new_frame([$fond.frame, $cible.frame])
	else:
		$score.text = str(- 1 + int($score.text))
		
