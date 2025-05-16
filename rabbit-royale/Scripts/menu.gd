extends Node3D
@onready var door_create: Node3D = $Settings/DoorCreate
@onready var door_join: Node3D = $Settings/DoorJoin
@onready var player: CharacterMenu = $Character_menu


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
	player.anim("Wave")
	door_create.open()
	door_join.open()
	var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property($GUI/Control/MarginContainer, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property($GUI/Control/MarginContainer, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	tween.tween_callback($GUI/Control/MarginContainer.hide)
	tween.tween_property(%Login, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)


func _on_obtions_pressed() -> void:
	pass # Replace with function body.
	
func _on_sortir_pressed() -> void:
	get_tree().quit()

func _on_register_pressed() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(%Login, "modulate", Color.TRANSPARENT, 1.0)
	tween.tween_callback(%Login.hide)
	tween.tween_callback(%Register.show)
	tween.tween_property(%Register, "modulate", Color.WHITE, 1.0)
