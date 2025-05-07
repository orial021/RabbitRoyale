extends Node3D

@onready var door_create: Node3D = $Settings/Door_Create
@onready var door_join : Node3D = $Settings/Door_Join
var enterGame : bool = false

func _ready() -> void:
	ResourceLoader.load_threaded_request("res://Scenas/level.tscn")
	
func _process(delta: float) -> void:
	if not enterGame:
		pass
	else:
		var scene_load_status = ResourceLoader.load_threaded_get_status("res://Scenas/level.tscn") 
		if scene_load_status == ResourceLoader.THREAD_LOAD_FAILED:
			get_tree().call_deferred("change_scene_to_packed", ResourceLoader.load_threaded_get("res://Scenas/level.tscn"))
		
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	enterGame = true

func _on_enter_pressed() -> void:
	door_create.open()
	door_join.open()
	$Dance.anim("Wave")
	
func _on_option_pressed() -> void:
	pass
	
func _on_exit_pressed() -> void:
	get_tree().quit()
