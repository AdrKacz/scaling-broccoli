extends Node

signal leaderboard(leaders, position)
signal error

var wait_get: bool = false
var wait_post: bool = false

const endpoint: String = "https://2a3q9k996b.execute-api.eu-west-3.amazonaws.com/Prod/"

var last_submitted_uuid: String
var last_submitted_name: String
var last_submitted_score: int

func _ready():
	# read from config if any
	var config = ConfigFile.new()
	var err = config.load("user://submission.cfg")
	if err != OK:
		last_submitted_uuid = "none"
	else:
		last_submitted_uuid = config.get_value('submission', 'uuid', "none")
		last_submitted_name = config.get_value('submission', 'name')
		last_submitted_score = config.get_value('submission', 'score')

func save_submission():
	var config = ConfigFile.new()
	config.set_value('submission', 'uuid', last_submitted_uuid)
	config.set_value('submission', 'name', last_submitted_name)
	config.set_value('submission', 'score', last_submitted_score)
	config.save("user://submission.cfg")
	print('Last Submission Saved (', last_submitted_uuid, ', ', last_submitted_name, ', ', last_submitted_score, ')')

func get_leaderboard():
	if wait_get:
		# TODO make sure we don't wait for too long if error serverside
		return
	var http_error = $HTTPRequestGet.request(endpoint + last_submitted_uuid)
	if http_error != OK:
		push_error("An error occurred in the HTTP request.")
		emit_signal("error")
	else:
		wait_get = true
		
func post_leaderboard(player_name: String, score: int):
	if wait_post:
		return
	var body = JSON.stringify({
		"name": player_name,
		"score": score
	})
	
	var http_error = $HTTPRequestPost.request(endpoint, [], HTTPClient.METHOD_POST, body)
	print('Post to leaderboard - ', http_error)
	print(body)
	if http_error != OK:
		push_error("An error occurred in the HTTP request.")
		emit_signal("error")
	else:
		wait_post = true
		last_submitted_name = player_name
		last_submitted_score = score
		
func process_response(body, method: String):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(response)
	if response == null:
		emit_signal("error")
		return
	var leaders = response.get('leaders', [])
	var position = response.get('position', 0)
	if method == "POST":
		last_submitted_uuid = response.get('uuid', 'none')
		save_submission()
	emit_signal("leaderboard", leaders.slice(0, 5), position)

func _on_http_request_get_request_completed(_result, _response_code, _headers, body):
	wait_get = false
	process_response(body, "GET")

func _on_http_request_post_request_completed(_result, _response_code, _headers, body):
	wait_post = false
	process_response(body, "POST")
