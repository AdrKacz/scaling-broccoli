extends RigidBody2D

signal explode(color)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get random color
	$UICharacter.modulate = Constants.State[randi() % Constants.State.size()]


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		_explode()
		
func emit_explode():
	emit_signal('explode', $UICharacter.modulate)

var tween: Tween
func _explode():
	if tween:
		return
	tween = create_tween().bind_node(self)
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	tween.tween_callback(emit_explode)
	tween.tween_property($UICharacter, 'scale', Vector2(), 1)
	tween.tween_callback(queue_free)
