extends Node3D

@onready var door_create:Node3D=$settings/DoorCreate
@onready var door_Join:Node3D=$settings/DoorJoin

var enterGame:bool=false


func _ready() -> void:
	ResourceLoader.load_threaded_request("res://Scenes/level.tscn")

func  _process(delta: float) -> void:
	if not enterGame:
		pass
	else:
		var scene_load_status=ResourceLoader.load_threaded_get("res://Scenes/level.tscn")
		if scene_load_status ==ResourceLoader.THREAD_LOAD_FAILED:
			get_tree().call_deferred("change_scene_to_packed",ResourceLoader.load_threaded_get("res://Scenes/level.tscn"))


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
