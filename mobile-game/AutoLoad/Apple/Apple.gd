extends Node
signal purchase_success(product_id: String)
signal purchase_in_progress(product_id: String)
signal purchase_error(product_id: String)

signal finish_transaction_in_progress(product_id: String)
signal finish_transaction_error(product_id: String)

var products: Dictionary = {}
var in_app_store
func _ready():
	if Engine.has_singleton("InAppStore"):
		in_app_store = Engine.get_singleton("InAppStore")
		$Timer.start()
		in_app_store.request_product_info({ "product_ids": ["hammers_10", "shields_10"] })
	else:
		print("iOS IAP plugin is not available on this platform.")

func purchase(product_id: String):
	var result = in_app_store.purchase({ "product_id": product_id })
	print('Purchase: ', product_id)
	if result == OK:
		print('Purchase in progress')
		emit_signal("purchase_in_progress", product_id)
	else:
		print('Cannot initiate purchase')
		emit_signal("purchase_error", product_id)
		
func finish_transaction(product_id: String):
	var result = in_app_store.finish_transaction(product_id)
	print('Finish transaction: ', product_id)
	if result == OK:
		print('Finish transaction in progress')
		emit_signal("finish_transaction_in_progress", product_id)
	else:
		print('Cannot finish transaction')
		emit_signal("finish_transaction_error", product_id)

func check_events():
	while in_app_store.get_pending_event_count() > 0:
		var event = in_app_store.pop_pending_event()
		print('Found event: ', event)
		if event.type == "purchase":
			if event.result == "ok":
				print('Purchase completed')
				emit_signal("purchase_success", event.product_id)
			elif event.result == "progress":
				print('Purchase in progress')
				emit_signal("purchase_in_progress", event.product_id)
			else:
				print('Cannot complete purchase')
				emit_signal("purchase_error", event.product_id)
		elif event.type == "product_info":
			if event.result == "ok":
				var ids: Array = event.ids
				var prices: Array = event.localized_prices # use localizsed to have currency too, prices only have number
				for i in ids.size():
					products[ids[i]] = prices[i]

func _on_timer_timeout():
	check_events()
