extends Node

var axis : Vector2
var con_use_heart : bool = true
var can_use_coin : bool = true
var can_use_shield : bool = true
var lives : int = 5
var time : int = -1
var sheep_dead : bool = false

func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	return axis.normalized()
	
	const HOST = "http://localhost:8000/"
#const HOST = "https://23w2sfqz-8000.use2.devtunnels.ms/"
var token : String
var headers = PackedStringArray()
var id : String
var username : String
var is_active : bool
var is_premium : bool
var coins : int
var kills : int
var deads : int
var wins : int
var matches_played : int
var match_id : int
var get_ready : bool = false
var is_online : bool = true
