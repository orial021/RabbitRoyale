extends MarginContainer

@onready var http_register: HTTPRequest = %HTTPRegister
var username : String
var password : String
var email : String
var gender : String
var json = JSON.new()
var data
var endpoint : String

func _on_registrer_pressed() -> void:
	$"../Sprite2D".show()
	username = %Username_Register.text
	password = %Password_Register.text
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
	endpoint = str(GLOBAL.HOST) + "user/create"
	http_register.request(endpoint, GLOBAL.headers, HTTPClient.METHOD_POST, json_data)
	

func _on_http_register_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	$"../Sprite2D".hidden()
	
