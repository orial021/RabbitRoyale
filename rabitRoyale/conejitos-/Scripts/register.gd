extends MarginContainer

var username : String
var password : String
var email : String
var gender : String
var json = JSON.new()
var data
var endpoint : String

func _on_exitregister_pressed() -> void:
	$"../charge_icon".show()
	username = %usernameregister.text
	password = %passwordregister.text
	email= %email.text
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
	$HTTPRequest.request(endpoint, Global.headers, HTTPClient.METHOD_POST, json_data)

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	$"../charge_icon".hide()
