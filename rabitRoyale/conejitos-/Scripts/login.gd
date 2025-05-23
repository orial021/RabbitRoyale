extends MarginContainer

@onready var http_login: HTTPRequest = $HTTPLogin
@onready var http_profile: HTTPRequest = $HTTPProfile
var json = JSON.new()
var endpoint : String
var password : String

func _process(delta: float) -> void:
	$"../charge_icon".rotation += 0.1

func _on_login_pressed() -> void:
	$"../charge_icon".visible = true
	Global.username = %username.text
	password = %password.text
	var data = "username=" + Global.username + "&password="  + password
	endpoint = Global.HOST + "auth/login"
	var headers = PackedStringArray()
	headers.push_back("Content-Type: application/x-www-form-urlencoded")
	http_login.request(endpoint, headers, HTTPClient.METHOD_POST, data)

func _on_http_login_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var body_parsed = json.parse(body_string)
		if body_parsed == OK:
			var data = json.get_data()
			profile(data["access_token"])

func profile(bearer: String) -> void:
	endpoint= Global.HOST + "auth/profile"
	var bearerheaders = PackedStringArray()
	bearerheaders.push_back("authorization: bearer " + bearer)
	http_profile.request(endpoint, bearerheaders, HTTPClient.METHOD_GET)


func _on_http_profile_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var body_parsed = json.parse(body_string)
		if body_parsed == OK:
			var data = json.get_data()
			Global.username = data["username"]
			Global.id = data["id"]
			Global.coins = data["coins"]
			Global.is_active = data["is_active"]
			Global.is_premium = data["is_premium"]
			Global.kills = data["kills"]
			Global.wins = data["wins"]
			Global.matches_played = data["matches_played"]
			Global.deads = data["deads"]
			print(data)
			%login.hide()
			$"../charge_icon".hide()
