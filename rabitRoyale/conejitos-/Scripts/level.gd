extends Node3D

@onready var path: PathFollow3D = $Path3D/PathFollow3D

var player = preload("res://scenes/player.tscn")
var enet_peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	multiplayer.server_relay = true
	if DisplayServer.get_name() == "headless":
		on_host.call_deferred()
	if Global.player_type == "host":
		print("host")
		on_host()
	else:
		
		print("client")
		on_join()
		
		
func _process(delta: float) -> void:
	path.set_progress(path.get_progress() + 8 * delta)
	
func on_host() -> void:
	enet_peer.create_server(Global.port)
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(create_player)
	create_player(multiplayer.get_unique_id())
	print("host terminado")
	
func on_join() -> void:
	enet_peer.create_client(Global.multipeerHost, Global.port)
	multiplayer.multiplayer_peer = enet_peer
	
func create_player(peer_id: int) -> void:
	print("creando jugador")
	var player_instance = player.instantiate()
	player_instance.name = str(peer_id)
	add_child(player_instance)
	player_instance.set_global_position(path.get_globlal_position())
