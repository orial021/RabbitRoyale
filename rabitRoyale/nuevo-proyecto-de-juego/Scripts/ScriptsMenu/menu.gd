extends Node3D
@onready var door_create : Node3D = $"Settings/Crear Partida"
@onready var door_join : Node3D = $Settings/Unirse
var enter_game : bool = false

func _ready() -> void:
	ResourceLoader.load_threaded_request("res://Scenes/level.tscn")

func _process(delta: float) -> void:
	if not enter_game:
		pass
	else:
		var scene_load_status = ResourceLoader.load_threaded_get_status("res://Scenes/level.tscn")
		if scene_load_status == ResourceLoader.THREAD_LOAD_FAILED:
			get_tree().call_deferred("change_scene_to_packed", ResourceLoader.load_threaded_get("res://Scenes/level.tscn"))


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
