class_name PlayerSync
extends MultiplayerSynchronizer

@onready var animations: AnimationTree = $"../AnimationTree"

var last_anim_state: String

func _process(delta: float) -> void:
	if is_multiplayer_authority() and animations.current_animation_state != last_anim_state:
		rpc("update_animation_state", animations.current_animation_state)
		last_anim_state = animations.current_animation_state
		


@rpc("any_peer","call_remote","unreliable")
func set_current_animation_state(new_state: String):
		if animations.current_animation_state != new_state:
			animations.current_animation_state = new_state
			rpc("remote_change_animation_state", new_state)

@rpc("any_peer","call_local","reliable")
func remote_change_animation_state(new_state: String):
		if animations.current_animation_state != new_state:
			animations.current_animation_state = new_state
			match new_state:
				animations.ANIMS.DEATH:
					animations.set(animations._death_path, true)
					animations.player.can_move = false
				animations.ANIMS.HURT:
					animations.set(animations._hurt_path, true)
					animations.player.can_move = false
					

@rpc("any_peer","call_remote","unreliable")
func update_animation_state(new_state: String):
	animations.current_animation_state = new_state
	animations._state_machine.travel(new_state)

@rpc("any_peer","call_local","reliable")
func remote_trigger_animation(trigger_name: String):
	match trigger_name:
		"hurt":
			animations.set(animations._hurt_path, true)
		"death":
			animations.set(animations._death_path, true)
