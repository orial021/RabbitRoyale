extends CharacterBody3D
class_name Player

@onready var gui: CanvasLayer
@onready var animations: AnimationTree = $AnimationTree
@onready var multiplayer_synchronizer: PlayerSync = $MultiplayerSynchronizer

@onready var HEAD: Node3D = $Head
@export var is_dead : bool = false
@export var id : String
@export var lives : int = 5
@export var is_vulnerable : bool = true
@export var kills : int = 0
@export var deads : int = 0
@export var username : String
var gravity : float = 2.0
var can_move : bool = true
var can_shot : bool = true
var is_respawning : bool = false
var using_scope : bool = false
var mouse_sensitivity : float = 0.05
var bullet=preload("res://Scenes/bullet.tscn")
const SPEED = 300
const SCOPING_SPEED = 120
const JUMP_FORCE = 40

func _enter_tree() -> void:
	Global.is_online = true
	set_multiplayer_authority(str(name).to_int())
 
func _ready() -> void:
	if not is_multiplayer_authority():
		set_physics_process(false)
		set_process(false)
		set_process_unhandled_input(false)
		set_process_input(false)
		return
	$Head/Camera3D.current=true
	id = Global.id
	username = Global.username
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	HEAD.set_rotation_degrees(Vector3.ZERO)

func _process(delta: float) -> void:
	$Head/Label3D.text=username+":"+str(lives)
	if using_scope:
		var current_scope=	$Head/Camera3D.fov
		$Head/Camera3D.fov=lerp(current_scope,50.0,5*delta)
	else:
		var current_scope=	$Head/Camera3D.fov
		$Head/Camera3D.fov=lerp(current_scope,100.0,5*delta)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event.is_action_pressed("ui_shot"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if not is_dead:
		if is_on_floor() and event.is_action_pressed("ui_select"):
			velocity.y = JUMP_FORCE
		if event.is_action_pressed("ui_shot") and can_shot:
			can_shot = true
			shot_ctrl()
		if event.is_action_pressed("ui_scope"):
			using_scope = true
		if event.is_action_released("ui_scope"):
			using_scope = false
@rpc("authority","call_local","reliable")
func shot_ctrl() -> void:
	var bullet_instance=bullet.instantiate()
	var direction :Vector3
	if $Head/RayCast3D.is_colliding():
		direction=$Head/RayCast3D.get_collision_point()-$Head/Marker3D1.global_position
	else:	
		direction=$Head/Sprite3D.global_position-$Head/Marker3D1.global_position
	get_parent().add_child(bullet_instance,true)
	bullet_instance.set_multiplayer_authority(multiplayer.get_unique_id())
	bullet_instance.direction=direction
	bullet_instance.set_global_position($Head/Marker3D1.get_global_position())
	bullet_instance.player_owner=self
	
@rpc("any_peer","call_local","reliable")
func damage_ctrl(attacker_name:String="")->void:
	if not is_multiplayer_authority():
		return
	animations.hurt()
	lives-=1	
 
func _physics_process(delta: float) -> void:
	velocity.y -= gravity
	if can_move:
		HEAD.rotation.x = clamp(HEAD.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		if not is_dead:
			$Head/Label3D.text = username + ": " + str(lives)
			anim_ctrl()
			motion_ctrl(delta)
			if velocity.y < -500:
				lives = 1
				
				global_position=Vector3(0,2,0)
				velocity=Vector3.ZERO
	if is_dead:
		$CharacterArmature/Skeleton3D/Body.transparency=0.5
		$CharacterArmature/Skeleton3D/Gun.transparency=0.5
		$CharacterArmature/Skeleton3D/Arms.transparency=0.5
		$CharacterArmature/Skeleton3D/Head.transparency=0.5
		$CharacterArmature/Skeleton3D/Gun/Gun.transparency=0.5
		$CharacterArmature/Skeleton3D/Ears.transparency=0.5
		if not is_respawning:
			is_respawning = true
			$Settings/Timer.start()
	move_and_slide()

func anim_ctrl() -> void:
	if is_on_floor() and Global.get_axis() != Vector2.ZERO and can_move:
		$Settings/GPUParticles3D.emitting=true	
	else:
		$Settings/GPUParticles3D.emitting=false

func motion_ctrl(delta) -> void:
	var direction = Global.get_axis().rotated(rotation.y)
	direction = Vector3(direction.x, 0, direction.y)
 
	if is_on_floor():
		if not using_scope:
			velocity.x = direction.x * -SPEED * delta
			velocity.z = direction.z * SPEED * delta
		else:
			velocity.x = direction.x * -SCOPING_SPEED * delta
			velocity.z = direction.z * SCOPING_SPEED * delta
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		HEAD.rotation_degrees.x-=event.relative.y * -mouse_sensitivity
		if not is_dead:
			rotation_degrees.y-=event.relative.x * mouse_sensitivity
		else:
			HEAD.rotation_degrees.y-=event.relative.x * mouse_sensitivity
	
	

	


func _on_timer_timeout() -> void:
	is_respawning=false
	
	if is_multiplayer_authority():
		get_parent().revive_player.rpc(name)

func full_transparency()->void:
		$CharacterArmature/Skeleton3D/Body.transparency=0.0
		$CharacterArmature/Skeleton3D/Gun.transparency=0.0
		$CharacterArmature/Skeleton3D/Arms.transparency=0.0
		$CharacterArmature/Skeleton3D/Head.transparency=0.0
		$CharacterArmature/Skeleton3D/Gun/Gun.transparency=0.0
		$CharacterArmature/Skeleton3D/Ears.transparency=0.0
