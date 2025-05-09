extends CharacterBody3D
class_name  Player

@onready var GUI: CanvasLayer
@onready var animation: AnimationTree= $AnimationTree
@onready var HEAD: Node3D = $Head
@export var is_dead : bool = false
@export var id : String
@export var lives : int = 5
@export var is_vulnerable : bool = true
@export var kills : int = 0
@export var deads : int
