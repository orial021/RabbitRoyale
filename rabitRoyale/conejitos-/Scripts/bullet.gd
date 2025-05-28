extends Area3D

@export var player_owner : Player
var direction
const SPEED = 3

func _process(delta: float) -> void:
	if direction:
		global_position += direction * SPEED * delta 
		

func _on_body_entered(body: Node3D) -> void:
	if not multiplayer.is_server():
		return
		
	if body is Player and body.is_vulnerable:
		body.damage_ctrl.rpc_id(body.get_multiplayer_authority(), player_owner.name)
		queue_free_ctrl.rpc()

func _on_timer_timeout() -> void:
	if multiplayer.is_server():
		rpc_id(1, "queue_free_ctrl")

@rpc("any_peer", "call_local", "reliable")
func queue_free_ctrl() -> void:
	if is_instance_valid(self):
		queue_free()
