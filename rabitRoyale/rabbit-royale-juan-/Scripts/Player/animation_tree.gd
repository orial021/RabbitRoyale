extends AnimationTree

var ANIMS: playerAnimation = playerAnimation.new()
var _hurt_path : String= "parameters/Hurt/request"
var _death_path : String = "parameters/Death/request"
var current_animation_state : String

@onready var player: Player
@onready var _state_machine: AnimationNodeStateMachinePlayback = get("parameters/StateMachine/playback")

func _ready() -> void:
	player = get_parent()
	

func _process(delta: float) -> void:
	state_machine()

func wave():
	_state_machine.travel(ANIMS.WAVE)

func run():
	_state_machine.travel(ANIMS.RUN)

func jump():
	_state_machine.travel(ANIMS.JUMP)

func jump_idle():
	_state_machine.travel(ANIMS.JUMP_IDLE)

func idle():
	_state_machine.travel(ANIMS.IDLE)

func walk():
	_state_machine.travel(ANIMS.WALK)

func land():
	_state_machine.travel(ANIMS.JUMP_LAND)

func run_shoot():
	_state_machine.travel(ANIMS.RUN_SHOOT)

func shoot():
	_state_machine.travel(ANIMS.SHOOT)

func hurt():
	current_animation_state = ANIMS.HURT
	set(_hurt_path, true)

func death():
	current_animation_state = ANIMS.DEATH
	set(_death_path,true)
	player.can_move = false
	player.deads += 1

func state_machine() -> void:
	match _state_machine.get_current_node():
		ANIMS.WAVE:
			current_animation_state = ANIMS.WAVE
		ANIMS.IDLE:
			current_animation_state = ANIMS.IDLE
			if GLOBAL.get_axis() != Vector2.ZERO:
				if not player.using_scope:
					run()
				else:
					walk()
			if Input.is_action_pressed("ui_accept"):
				jump()
			if Input.is_action_pressed("ui_shot"):
				shoot()
		ANIMS.RUN:
			current_animation_state = ANIMS.RUN
			if GLOBAL.get_axis() == Vector2.ZERO:
				idle()
			if Input.is_action_pressed("ui_accept"):
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
