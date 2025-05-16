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
	
