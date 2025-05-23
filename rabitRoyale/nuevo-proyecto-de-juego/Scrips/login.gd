extends MarginContainer

@onready var http_login : HTTPRequest = $HTTPRequest
@onready var http_profile : HTTPRequest = $HTTPRequest2
var json = JSON.new()
var endpoint : String
var password : String

func _process(delta: float) -> void:
	$"../Sprite2D".rotation += 0.1
	
func _on_login_pressed() -> void:
	$"../Sprite2D".visible = true
	GLOBAL.username = %USERNAME.text
	password = %PASSWORD.text
	var data = "username=" + GLOBAL.username + "&password=" + password
	endpoint = GLOBAL.HOST + "auth/login"
	var headers = PackedStringArray()
	headers.push_back("Content-Type: application/x-www-from-urlencoded")
	http_login.request(endpoint, headers, HTTPClient.METHOD_POST, data)
	


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	$"../Sprite2D".hide()
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var body_parsed = json.parse(body_string)
		if body_parsed == OK:
			var data = json.get_data()
			profile(data["access_token"])
			
func profile(Bearer : String) -> void:
	endpoint = GLOBAL.HOST + "aut/profile"
	var Bearehearders = PackedStringArray()
	Bearehearders.push_back("Authorization: Bearer " + Bearer)
	http_profile.request(endpoint, Bearehearders, HTTPClient.METHOD_GET)

func _on_http_request_2_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var body_parsed = json.parse(body_string)
		if body_parsed == OK:
			var data = json.get_data()
			GLOBAL.username = data["username"]
			GLOBAL.id = data["id"]
			GLOBAL.coins = data["coins"]
			GLOBAL.is_active = data["is_active"]
			GLOBAL.is_premium = data["is_premium"]
			GLOBAL.kills = data["kills"]
			GLOBAL.wins = data["wins"]
			GLOBAL.matches_played = data["matches_played"]
			GLOBAL.deads = data["deads"]
			%login.hide()
