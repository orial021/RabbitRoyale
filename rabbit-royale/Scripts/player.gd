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
var can_move : bool = false
var can_shot : bool = true
var is_respawning : bool = false
var using_scope : bool = false

const SPEED = 300
const SCOPING_SPEED = 120
const JUMP_FORCE = 40
