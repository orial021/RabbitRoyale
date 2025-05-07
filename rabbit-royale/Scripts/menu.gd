extends Node3D
@onready var door_create: Node3D = $Settings/DoorCreate
@onready var door_join: Node3D = $Settings/DoorJoin
var enterGame : bool = false

func _ready() -> void:
	ResourceLoader.load_threaded_request("res://Scenes/menu.tscn")

func _process(delta: float) -> void:
	if not enterGame:
		pass
	else:
		var scene_load_status = ResourceLoader.load_threaded_get_status("res://Scenes/level.tscn")
		if scene_load_status == ResourceLoader.THREAD_LOAD_FAILED:
			get_tree().call_deferred("change_scene_to_packed", ResourceLoader.load_threaded_get("res://Scenes/level.tscn"))

func _on_area_3d_body_entered(body: Node3D) -> void:
	enterGame = true

func _on_entré_pressed() -> void:
	door_create.open()
	door_join.open()
	$Character_menu.anim("Wave")

func _on_obtions_pressed() -> void:
	pass # Replace with function body.
	
func _on_sortir_pressed() -> void:
	get_tree().quit()
