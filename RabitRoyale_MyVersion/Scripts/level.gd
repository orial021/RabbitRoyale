extends Node3D

@onready var path: PathFollow3D = $Path3D/PathFollow3D

var PLAYER=preload("res://Scenes/player.tscn")
var enet_peer=ENetMultiplayerPeer.new()

func _ready() -> void:
	multiplayer.server_relay=true
	if DisplayServer.get_name()=="headless":
		on_host.call_deferred()
	if Global.player_type=="host":
		on_host()
	else:
		on_join()
func _process(delta: float) -> void:
	path.set_progress(path.get_progress()+8*delta)		
	
func on_host()->void:
	enet_peer.create_server(Global.PORT)
	multiplayer.multiplayer_peer=enet_peer
	
	multiplayer.peer_connected.connect(create_player)
	create_player(multiplayer.get_unique_id())
	
func on_join()->void:
	enet_peer.create_client(Global.multipeerHost,Global.PORT)
	multiplayer.multiplayer_peer=enet_peer

func create_player(peer_id:int)->void:
	var player = PLAYER.instantiate()
	player.name=str(peer_id)
	add_child(player)
	player.velocity.x=0
	player.velocity.z=0
	player.set_global_position(path.get_global_position())
	
	player.set_global_position(path.get_global_position())

@rpc("any_peer", "call_local", "reliable")
func revive_player(player_name : String) -> void:
	var player = get_node_or_null(player_name)
	if player:
		player.lives = 5
		player.is_dead = false
		player.can_move = true
		player.is_vulnerable = true
		player.velocity = Vector3.ZERO
		player.rotation_degrees.y = 0
		player.HEAD.rotation_degrees = Vector3.ZERO
		player.set_global_position(path.get_global_position())
		player.animations.active = true
		player.animations.idle()
		player.player_sync.remote_change_animation_estate.rpc("Idle")
		player.full_transparency()
	
	
	
	
	
	
