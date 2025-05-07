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
	move_and_slide()
		
func motion_ctrl()->void:
	'''MOVIMIENTO'''
	velocity.y-=GRAVITY
	velocity.x=Global.get_axixs().x*SPEED
	velocity.z=Global.get_axixs().y* -SPEED

	'''ANIMACIONES'''
	match is_on_floor():
		true:
			if Global.get_axixs() != Vector2.ZERO:
				$AnimationPlayer.play("Walk")
			else:
				$AnimationPlayer.play("Idle")
				

	'''Rotacion'''
	if Global.get_axixs() != Vector2.ZERO:
		angle=atan2(Global.get_axixs().x, -Global.get_axixs().y)
		rot=get_rotation()
		rot.y=angle
		set_rotation(rot)
func anim(anim_name : String)->void:
	$AnimationPlayer.play(anim_name)




	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="wave":
		can_move=true
