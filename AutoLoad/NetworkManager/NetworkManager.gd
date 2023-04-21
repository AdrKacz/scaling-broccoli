extends Node

signal scan(result)
signal insert(result)

var is_scanning = false
var is_inserting = false

const apiEndpoint = "https://infinite-mesa-72950.herokuapp.com/"

func start_scan():
	if is_scanning:
		print("Already scanning")
		return
	print("Scan")
	var error = $HTTPRequestScan.request(apiEndpoint + "scan")
	if error != OK:
		push_error("An error occurred in the HTTP request [scan].")
	else:
		is_scanning = true
		
func start_insert(score, player_name):
	if is_inserting or is_scanning:
		print("Already inserting")
		return
	print("Insert: ", score, ", ", player_name)
	var body = {"score": score, "name": player_name}
	var error = $HTTPRequestInsert.request(apiEndpoint + "insert", ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(body))
	if error != OK:
		push_error("An error occurred in the HTTP request [insert, %d, %s]." % [score, player_name])
	else:
		is_inserting = true


func _on_HTTPRequestInsert_request_completed(_result, _response_code, _headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var response = test_json_conv.get_data()
	if response and response.has("result"):
		emit_signal("insert", response["result"])
	is_inserting = false

func _on_HTTPRequestScan_request_completed(_result, _response_code, _headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var response = test_json_conv.get_data()
	if response and response.has("result"):
		emit_signal("scan", response["result"])
	is_scanning = false
	
