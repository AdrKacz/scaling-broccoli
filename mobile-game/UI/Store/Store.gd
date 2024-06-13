extends CanvasLayer
signal exit

var latest_product_id: String
# Called when the node enters the scene tree for the first time.
func _ready():
	$PurchaseResult.visible = false
	$Control/MarginContainer/CenterContainer.visible = Apple.in_app_store != null
	Apple.purchase_success.connect(_on_Apple_purchase_success)
	Apple.purchase_in_progress.connect(_on_Apple_purchase_in_progress)
	Apple.purchase_error.connect(_on_Apple_purchase_error)

func _on_exit_texture_button_pressed():
	emit_signal("exit")

func _on_hammers_pressed():
	print('Buy hammers')
	Apple.purchase("hammers_10")
	latest_product_id = "hammers_10"
	toggle_buttons(false)
	
func _on_shields_pressed():
	print('Buy shields')
	Apple.purchase("shields_10")
	latest_product_id = "shields_10"
	toggle_buttons(false)

func _on_Apple_purchase_success(product_id: String):
	print('Purchase success: ', product_id)
	var items: String = "Unknown"
	if product_id == 'hammers_10':
		Memory.hammers += 10
		items = "10 Hammers"
		Apple.finish_transaction(product_id)
	elif product_id == "shields_10":
		Memory.shields += 10
		Session.active_shields = min(3, Memory.shields)
		items = "10 Shields"
		Apple.finish_transaction(product_id)
	else:
		print('Unknown product, transaction not completed.')
	toggle_buttons(true)
	toggle_purchase_result(true, items, true)
	
func _on_Apple_purchase_in_progress(product_id: String):
	print('Purchase in progress: ', product_id)
	
func _on_Apple_purchase_error(product_id: String):
	print('Purchase error: ', product_id)
	toggle_buttons(true)
	var items: String = "Unknown"
	if product_id == "hammers_10":
		items = "10 Hammers"
	elif product_id == "shields_10":
		items = "10 Shields"
	toggle_purchase_result(true, items, false)

func _on_exit_purchase_result_pressed():
	toggle_purchase_result(false)

func _on_purchase_error_retry():
	$PurchaseResult.visible = false
	Apple.purchase(latest_product_id)
	toggle_buttons(false)
	
func toggle_purchase_result(on: bool, items: String = "", with_success: bool = true):
	$PurchaseResult/CenterContainer/PurchaseSuccess.items = items
	$PurchaseResult/CenterContainer/PurchaseError.items = items
	
	$PurchaseResult/CenterContainer/PurchaseSuccess.visible = with_success
	$PurchaseResult/CenterContainer/PurchaseError.visible = not with_success
	
	$Control/Blur.visible = not on
	$PurchaseResult/Blur.visible = on
	$PurchaseResult.visible = on
	
func toggle_buttons(button_enabled: bool):
	$Control/MarginContainer/CenterContainer/VBoxContainer/Hammers.disabled = not button_enabled
	$Control/MarginContainer/CenterContainer/VBoxContainer/Shields.disabled = not button_enabled
