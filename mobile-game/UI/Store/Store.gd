extends CanvasLayer
signal exit

# Called when the node enters the scene tree for the first time.
func _ready():
	$PurchaseResult.visible = false
	$Control/MarginContainer/CenterContainer.visible = Apple.in_app_store != null
	Apple.purchase_success.connect(_on_Apple_purchase_success)
	Apple.purchase_in_progress.connect(_on_Apple_purchase_in_progress)
	Apple.purchase_error.connect(_on_Apple_purchase_error)

func _on_exit_texture_button_pressed():
	emit_signal("exit")

func _on_hammer_product_pressed():
	print('Buy hammers')
	Apple.purchase("hammers_10")
	$Control/MarginContainer/CenterContainer/VBoxContainer/HammerProduct.disabled = true

func _on_Apple_purchase_success(product_id: String):
	print('Purchase success: ', product_id)
	$Control/MarginContainer/CenterContainer/VBoxContainer/HammerProduct.disabled = false
	toggle_purchase_result(true, true)
	# Save purchase
	Memory.hammers += 10
	Apple.finish_transaction(product_id)
	
func _on_Apple_purchase_in_progress(product_id: String):
	print('Purchase in progress: ', product_id)
	
func _on_Apple_purchase_error(product_id: String):
	print('Purchase error: ', product_id)
	$Control/MarginContainer/CenterContainer/VBoxContainer/HammerProduct.disabled = false
	toggle_purchase_result(true, false)

func _on_exit_purchase_result_pressed():
	toggle_purchase_result(false)

func _on_purchase_error_retry():
	$PurchaseResult.visible = false
	_on_hammer_product_pressed()
	
func toggle_purchase_result(on: bool, with_success: bool = true):
	$PurchaseResult/CenterContainer/PurchaseSuccess.visible = with_success
	$PurchaseResult/CenterContainer/PurchaseError.visible = not with_success
	$Control/Blur.visible = not on
	$PurchaseResult/Blur.visible = on
	$PurchaseResult.visible = on
