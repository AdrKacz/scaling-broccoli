extends Node

signal leaderboard(leaders, position)

var wait_get: bool = false
var wait_post: bool = false

const endpoint: String = ""
var lastUUID: String = "none"

func get_leaderboard():
	if wait_get:
		# TODO make sure we don't wait for too long if error serverside
		return
	var error = $HTTPRequestGet.request(endpoint + lastUUID)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	else:
		wait_get = true
		
func post_leaderboard(player_name: String, score: int):
	if wait_post:
		return
	var body = JSON.stringify({
		"name": player_name,
		"score": score
	})
	
	var error = $HTTPRequestPost.request(endpoint, [], HTTPClient.METHOD_POST, body)
	print('Post to leaderboard - ', error)
	print(body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	else:
		wait_post = true
		
func process_response(body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(response)
	if response == null:
		return
	var leaders = response.get('leaders', [])
	var position = response.get('position', 0)
	emit_signal("leaderboard", leaders, position)

func _on_http_request_get_request_completed(_result, _response_code, _headers, body):
	wait_get = false
	process_response(body)

func _on_http_request_post_request_completed(_result, _response_code, _headers, body):
	wait_post = false
	process_response(body)
