extends Node
signal purchase_success
signal purchase_in_progress
signal purchase_error

var in_app_store

func _ready():
	if Engine.has_singleton("InAppStore"):
		in_app_store = Engine.get_singleton("InAppStore")
		$Timer.start()
	else:
		print("iOS IAP plugin is not available on this platform.")

func purchase(product_id: String):
	var result = in_app_store.purchase({ "product_id": product_id })
	if result == OK:
		print('Purchase in progress')
		emit_signal("purchase_in_progress") # show the "waiting for response" animation
	else:
		print('Cannot initiate purchase')
		emit_signal("purchase_error")

func check_events():
	while in_app_store.get_pending_event_count() > 0:
		var event = in_app_store.pop_pending_event()
		if event.type == "purchase":
			if event.result == "ok":
				print('Purchase completed')
				emit_signal("purchase_success")
			else:
				print('Cannot complete purchase')
				emit_signal("purchase_error")

func _on_timer_timeout():
	check_events()
