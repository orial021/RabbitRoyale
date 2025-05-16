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
	var data = "username" + Global.username + "&password="  + password
	endpoint = Global.HOST + "auth/login"
	var headers = PackedStringArray()
	headers.push_back("Content-type: application/x-www-form-urlencoded")
	http_login.request(endpoint, headers, HTTPClient.METHOD_POST)
