extends Node


signal auth_completed
signal list_loaded(dict)

var game_API_key = "dev_b4bf1b63b4af4130b2a8b4c4641542da"
var leaderboard_key = "18022"
var development_mode = true
var session_token = ""

# API Calls
const BASE_URL = "https://api.lootlocker.io/game"
const AUTH = "/v2/session/guest"
const LEADERBOARD = "/leaderboards"
const GET_LIST = "/list?count=10"
const SUBMIT_SCORE= "/submit"


# Implementation


func _print_call(url, headers, data):
	print("URL: " + url + "\nHeaders: " + str(headers) + "\nData: " + JSON.stringify(data))


func _print_response(code, body):
	print("Request finished with code %s" % code)
	print("Body: %s" % body)


func parse_response(body) -> Variant:
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	
	if error == OK:
		return json.data
	else:
		printerr(json.get_error_message())
		return null


# Public API


func auth_user():
	print("Authenticating Player...")
	
	var request = HTTPRequest.new()
	var url = BASE_URL + AUTH
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	var data = {
		"game_key": game_API_key,
		"game_version": "0.10.0.0"
	}
	
	var id = GameManager.get_user_id()
	if id != "":
		data = {
			"game_key": game_API_key,
			"player_identifier": id,
			"game_version": "0.10.0.0"
		}
	
	_print_call(url, headers, data)
	
	add_child(request)
	request.request(url, headers, method, JSON.stringify(data))
	request.request_completed.connect(self._on_auth_user_completed)


func is_authenticated() -> bool:
	return session_token != ""


func get_highscore():
	print("\nGetting Highscore List...")
	
	var request = HTTPRequest.new()
	var url = BASE_URL + LEADERBOARD + "/" + leaderboard_key + GET_LIST
	var headers = ["x-session-token: " + session_token]
	var method = HTTPClient.METHOD_GET
	
	_print_call(url, headers, "")
	
	add_child(request)
	request.request(url, headers, method)
	request.request_completed.connect(self._on_get_highscore_completed)


func post_score(score: int):
	print("\nPosting Score")
	
	var request = HTTPRequest.new()
	var url = BASE_URL + LEADERBOARD + "/" + leaderboard_key + SUBMIT_SCORE
	var headers = ["Content-Type: application/json", "x-session-token: " + session_token]
	var method = HTTPClient.METHOD_POST
	var data = {
		"score": score,
		"member_id": GameManager.get_username()
	}
	
	_print_call(url, headers, data)
	
	add_child(request)
	request.request(url, headers, method, JSON.stringify(data))
	request.request_completed.connect(self._on_post_score_completed)


# Listeners


func _on_auth_user_completed(result, response_code, headers, body):
	var data = parse_response(body)
	
	if data == null:
		return
	if not data.success:
		printerr(data)
		return
	
	session_token = data.session_token
	
	var id = GameManager.get_user_id()
	if id == "":
		GameManager.update_userdata("", 0, data.player_identifier)
	
	_print_response(response_code, data)
	auth_completed.emit()


func _on_get_highscore_completed(result, response_code, headers, body):
	var data = parse_response(body)
	
	if data == null:
		return
	
	var dict = {}
	for item in data.items:
		dict[item.member_id] = item.score
	
	print(dict)
	list_loaded.emit(dict)


func _on_post_score_completed(result, response_code, headers, body):
	var data = parse_response(body)
	
	if data == null:
		return
	if response_code != 200:
		printerr(data)
		return
	
	_print_response(response_code, data)
