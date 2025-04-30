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
	axis.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_right"))
	
