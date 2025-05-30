extends Node3D

@onready var path: PathFollow3D = $Path3D/PathFollow3D

var PLAYER = preload("res://Scenes/player.tscn")
var enet_peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	multiplayer.server_relay = true
	if DisplayServer.get_name() == "headless":
		on_host.call_deferred()
	if GLOBAL.player_type == "host":
		on_host()
	else:
		on_join()

func _process(delta: float) -> void:
	path.set_progress(path.get_progress() * 8 * delta)
	

func on_host():
	enet_peer.create_server(GLOBAL.PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(create_player)
	create_player(multiplayer.get_unique_id())

func on_join():
	enet_peer.create_client(GLOBAL.multipeerHost, GLOBAL.PORT)
	multiplayer.multiplayer_peer = enet_peer
	

func create_player(peer_id:int):
	var player_instance = PLAYER.instantiate()
	player_instance.name = str(peer_id)
	add_child(player_instance)
	player_instance.velocity.x = 0
	player_instance.velocity.z = 0
	player_instance.set_global_position(path.get_global_position())


@rpc("any_peer","call_local","reliable")
func revive_player(player_name : String):
	var player = get_node_or_null(player_name)
	if player_name:
		player.lives = 5
		player.is_dead = false
		player.can_move = true
		player.is_vulnerable = true
		player.velocity = Vector3.ZERO
		player.rotation_degrees.y = 0
		player.HEAD_rotation_degrees = Vector3.ZERO
		player.set_global_position(path.get_global_position())
		player.animations.active = true
		player.animations.idle()
		player.player_sync.remote_change_animation_state.rpc("Idle")
		player.full_transparency()
