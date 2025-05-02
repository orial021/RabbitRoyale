extends CharacterBody3D
class_name CharacterMenu

var can_move: bool = false
var rot: Vector3
var angle: float
const SPEED= 6
const GRAVITY= 2
const JUMP= 26

func _process(delta: float) -> void:
	if can_move:
		motion_ctrl()
	

func motion_ctrl() -> void:
	'''MOVIMIENTO'''
	velocity.y -= GRAVITY
	velocity.x = GLOBAL.get_axis().x * SPEED
	velocity.z = GLOBAL.get_axis().y * -SPEED
