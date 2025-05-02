extends CharacterBody3D
class_name CharacterMenu

var can_move:bool=false
var rot:Vector3
var angle:float
var SPEED=6
var GRAVITY=2
var JUMP=26

func _process(delta: float) -> void:
	if can_move:
		motion_ctrl()
		
		
func motion_ctrl()->void:
	'''MOVIMIENTO'''
	velocity.y-=GRAVITY
	velocity.x=Global.get_axixs().x*SPEED
	velocity.z=Global.get_axixs().y* -SPEED
