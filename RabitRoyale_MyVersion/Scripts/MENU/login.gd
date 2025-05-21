extends MarginContainer

@onready var http_login: HTTPRequest = $HTTPLogin
@onready var http_profile: HTTPRequest = $HTTPProfile
var json = JSON.new()
var endpoint:String
var password:String
func _process(delta: float) -> void:
	$"../Charge_icon".rotation+=0.1
	
func _on_login_pressed() -> void:
	$"../Charge_icon".visible=true 
	Global.username =%Username.text
	password =%Password.text
	var data ="username=" + Global.username + "&password=" +password
	endpoint = Global.HOST +"auth/login"
	var headers =PackedStringArray()
	headers.push_back("Content-type: application/x-www-form-urlencoded")
	http_login.request(endpoint,headers,HTTPClient.METHOD_POST,data)
	


func _on_http_login_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	$"../Charge_icon".hide()
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var body_parsed = json.parse(body_string)
		if body_parsed == OK:
			var data=json.get_data()
			#Global.token=data["acces_Token"]
			profile(data["access_token"])
		
func profile(bearer:String)->void:
	endpoint=Global.HOST + "auth/profile"
	var bearerHeaders=PackedStringArray()
	bearerHeaders.push_back("Authorization: Bearer " + bearer)
	http_profile.request(endpoint,bearerHeaders, HTTPClient.METHOD_GET)
	


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
			%Login.hide()
			
