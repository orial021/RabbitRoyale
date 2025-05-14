extends CharacterBody3D
class_name Player

@onready var gui: CanvasLayer
@onready var animations: AnimationTree = $AnimationTree
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

const SPEED = 300
const SCOPING_SPEED = 120
const JUMP_FORCE = 40

func _enter_tree() -> void:
	Global.is_online = true
	
func _ready() -> void:
	id = Global.id
	username = Global.username
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	HEAD.set_rotation_degrees(Vector3.ZERO)
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event.is_action_pressed("ui_shot"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if not is_dead:
		if is_on_floor() and event.is_action_pressed("ui_select"):
			velocity.y = JUMP_FORCE
		if event.is_action_pressed("ui_shot") and can_shot:
			can_shot = false
			shot_ctrl()
		if event.is_action_pressed("ui_scope"):
			using_scope = true
		if event.is_action_released("ui_scope"):
			using_scope = false

func shot_ctrl() -> void:
	pass

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
	if is_dead:
		if not is_respawning:
			is_respawning = true
			#$Settings/TimerRespawn.start()
	move_and_slide()

func anim_ctrl() -> void:
	pass

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
			
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		HEAD.rotation_degrees.x -= event.relative.y * -mouse_sensitivity
		if not is_dead:
			rotation_degrees.y -= event.relative.x * mouse_sensitivity
		else:
			HEAD.rotation_degrees.y -= event.relative.x * mouse_sensitivity
