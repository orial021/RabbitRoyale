extends CharacterBody3D

class_name CharacterMenu

var can_move : bool = true
var rot: Vector3
var angle : float 
const SPEED = 6
const GRAVITY = 2
const JUMP = 26
func _process(delta: float) -> void:
	if can_move:
		motion_ctrl()
	move_and_slide()
		
func motion_ctrl() -> void:
	velocity.y -= GRAVITY
	velocity.x = Global.get_axis().x * SPEED
	velocity.z = Global.get_axis().y * - SPEED

	match is_on_floor():
		true: 
			if Global.get_axis() != Vector2.ZERO:
				$AnimationPlayer.play("Walk")
			else:
				$AnimationPlayer.play("Idle")
				
				
	if Global.get_axis() != Vector2.ZERO:
		angle = atan2(Global.get_axis().x , -Global.get_axis().y)
		rot =get_rotation()
		rot.y = angle
		set_rotation(rot)
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "wave":
		can_move = true
