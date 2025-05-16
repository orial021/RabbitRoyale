extends MarginContainer

@onready var http_register: HTTPRequest = $HTTPRegister

var username : String
var password : String
var email : String
var gender : String
var json = JSON.new()
var data
var endpoint : String



func _on_register_pressed() -> void:
	$"../Change_icon".show()
	username = %usernameregister.text
	password = %passwordregister.text
	email = %email.text
	var option_button = %Gender
	gender = option_button.get_item_text(option_button.selected).to_lower()
	data = {
		"username" : username,
		"password" : password,
		"email" : email,
		"gender" : gender,
		"date_of_birth": "2025-04-08T03:30:02.490Z"
	}
	var json_data = JSON.stringify(data)
	endpoint = str(Global.HOST) + "user/create"
	http_register.request(endpoint, Global.headers, HTTPClient.METHOD_POST, json_data)


func _on_http_register_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	$"../Change_icon".hide()
