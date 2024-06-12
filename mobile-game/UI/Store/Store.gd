extends CanvasLayer
signal exit

@onready var loading_label: Label = $LoadingControl/CenterContainer/Label
var tween: Tween
var is_loading: bool:
	get:
		return $LoadingControl.visible
	set(value):
		print('Update Loading visibility: ', value)
		$LoadingControl.visible = value
		if tween:
			tween.kill()
		if value:
			var text = loading_label.text.rstrip('.')
			tween = get_tree().create_tween().bind_node(self)
			tween.set_loops()
			tween.set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
			for i in 4:
				tween.tween_callback(update_loading_label.bind(text, i)).set_delay(0.5)

func update_loading_label(base: String, count: int):
	var dots: String = ""
	for i in count:
		dots += "."
	loading_label.text = base + dots

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/MarginContainer/CenterContainer.visible = Apple.in_app_store != null
	Apple.purchase_success.connect(_on_Apple_purchase_success)
	Apple.purchase_in_progress.connect(_on_Apple_purchase_in_progress)
	Apple.purchase_error.connect(_on_Apple_purchase_error)

func _on_exit_texture_button_pressed():
	emit_signal("exit")

func _on_hammer_product_pressed():
	print('Buy hammer pressed')
	Apple.purchase("hammers_10")
	is_loading = true

func _on_Apple_purchase_success(product_id: String):
	print('Success, bought: ', product_id)
	is_loading = false
	
func _on_Apple_purchase_in_progress():
	print('Purchase in progress')
	
func _on_Apple_purchase_error():
	print('Error with purchase')
	is_loading = false
