extends AnimationTree

var ANIMS : playerAnimation = playerAnimation.new()

var _hurt_path : String = "parameters/Hurt/request"
var _death_path : String = "parameters/Death/request"
var current_animation_state : String

@onready var player : Player
@onready var _state_machine : AnimationNodeStateMachinePlayback = get("parameters/StateMachine/playback")

func _ready() -> void:
	player = get_parent()
	
func _process(delta: float) -> void:
	if player.is_multiplayer_authority():
		state_machine()

func wave() -> void:
	_state_machine.travel(ANIMS.WAVE)
	
func idle():
	_state_machine.travel(ANIMS.IDLE)
	
func run() -> void:
	_state_machine.travel(ANIMS.RUN)
	
func walk() -> void:
	_state_machine.travel(ANIMS.WALK)
	
func jump() -> void:
	_state_machine.travel(ANIMS.JUMP)
	
func jump_idle() -> void:
	_state_machine.travel(ANIMS.JUMP_IDLE)
	
func land() -> void:
	_state_machine.travel(ANIMS.JUMP_LAND)
	
func run_shoot()-> void:
	_state_machine.travel(ANIMS.RUN_SHOOT)

func shoot() -> void:
	_state_machine.travel(ANIMS.SHOOT)
	
func hurt() -> void:
	current_animation_state = ANIMS.HURT
	set(_hurt_path, true)
	
func death() -> void:
	current_animation_state = ANIMS.DEATH
	set(_death_path, true)
	player.can_move = false
	player.deads += 1
	
func state_machine() -> void:
	match _state_machine.get_current_node():
		ANIMS.WAVE:
			current_animation_state = ANIMS.WAVE
			
		ANIMS.IDLE:
			current_animation_state = ANIMS.IDLE
			if  Global.get_axis() != Vector2.ZERO:
				run()
			if Input.is_action_pressed("ui_accept"):
				jump()
			if Input.is_action_pressed("ui_shot"):
				shoot()
		
		ANIMS.RUN:
			current_animation_state = ANIMS.RUN
			if Global.get_axis() == Vector2.ZERO:
				idle()
			if Input.is_action_pressed("ui_jump"):
				jump()
			if Input.is_action_pressed("ui_shot"):
				run_shoot()
		
		ANIMS.JUMP:
			current_animation_state = ANIMS.JUMP
			if player.velocity.y < 0:
				land()
			if Input.is_action_pressed("ui_shot"):
				shoot()
		
		ANIMS.JUMP_LAND:
			current_animation_state = ANIMS.JUMP_LAND
			if player.is_on_floor():
				idle()
		
		ANIMS.RUN_SHOOT:
			current_animation_state = ANIMS.RUN_SHOOT
			
		ANIMS.SHOOT:
			current_animation_state = ANIMS.SHOOT


func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		ANIMS.WAVE:
			player.can_move = true
		ANIMS.HURT:
			player.can_move = true




func _on_animation_started(anim_name: StringName) -> void:
	match  anim_name:
		ANIMS.WAVE:
			player.can_move = false
		ANIMS.HURT:
			set(_hurt_path, false)
			player.can_move = false
			player.velocity.x = 0
			player.velocit.y = 0
			if player.lives <= 0:
				player.is_vulnerable = false
				player.is_dead = true
				death()
		ANIMS.DEATH:
			set(_death_path, false)
