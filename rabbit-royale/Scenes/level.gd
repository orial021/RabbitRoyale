extends Node3D

@onready var path : PathFollow3D = $Path3D/PathFollow3D

var PLAYER = preload("res://Scenes/player.tscn")
var enet_peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	multiplayer.server_relay = true
	if DisplayServer.get_name() == "headless":
		on_host.call_deferred()
	if Global.player_type == "host":
		on_host()
	else:
		on_join()
		
func _process(delta: float) -> void:
	path.set_progress(path.get_progress() + 8 * delta)
		
func on_host() -> void:
	enet_peer.create_server(Global.PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(create_player)
	create_player(multiplayer.get_unique_id())
	
func on_join() -> void:
	enet_peer.create_client(Global.multipeerHost, Global.PORT)
	multiplayer.multiplayer_peer = enet_peer

func create_player(peer_id: int) -> void:
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	add_child(player)
	player.set_global_position(path.get_global_position())
