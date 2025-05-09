extends Node3D
class_name  PlayerAnimate

@onready var gui : CanvasLayer
@onready var animations : AnimationTree = $AnimationTree
@onready var HEAD : Node3D = $Head
@onready var is_dead : bool = false
@onready var id : String
@onready var lives : int = 5
@onready var is_vulnerable : bool = true
@onready var kills : int = 0
@onready var deads : int = 0
@onready var username : String
var gravity : float = 2.0
var can_move : bool = false
var can_shot : bool = true
var is_respawning : bool = false
var using_scope : bool = false

const SPEED = 300
const SCOPING_SPEED = 120
const JUMP_FORCE = 40
