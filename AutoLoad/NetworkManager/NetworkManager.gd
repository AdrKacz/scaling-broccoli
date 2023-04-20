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
		
func start_insert(score, name):
	if is_inserting or is_scanning:
		print("Already inserting")
		return
	print("Insert: ", score, ", ", name)
	var body = {"score": score, "name": name}
	var error = $HTTPRequestInsert.request(apiEndpoint + "insert", ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.new().stringify(body))
	if error != OK:
		push_error("An error occurred in the HTTP request [insert, %d, %s]." % [score, name])
	else:
		is_inserting = true


func _on_HTTPRequestInsert_request_completed(result, response_code, headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var response = test_json_conv.get_data()
	if response and response.has("result"):
		emit_signal("insert", response["result"])
	is_inserting = false

func _on_HTTPRequestScan_request_completed(result, response_code, headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var response = test_json_conv.get_data()
	if response and response.has("result"):
		emit_signal("scan", response["result"])
	is_scanning = false
	
