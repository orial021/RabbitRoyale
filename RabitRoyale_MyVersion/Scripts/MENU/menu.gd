extends Node3D

@onready var door_create:Node3D=$settings/DoorCreate
@onready var door_Join:Node3D=$settings/DoorJoin
@onready var player:CharacterMenu=$Character_menu

var enterGame:bool=false


func _ready() -> void:
	ResourceLoader.load_threaded_request("res://Scenes/level.tscn")

func  _process(delta: float) -> void:
	if not enterGame:
		pass
	else:
		var scene_load_status=ResourceLoader.load_threaded_get_status("res://Scenes/level.tscn")
		if scene_load_status ==ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().call_deferred("change_scene_to_packed",ResourceLoader.load_threaded_get("res://Scenes/level.tscn"))


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterMenu:
		print("entrandi")
		enterGame=true
	



func _on_enter_pressed() -> void:
	door_create.open()
	door_Join.open()
	$Character_menu.anim("Wave")
	var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property($GUI/Control/MarginContainer, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property($GUI/Control/MarginContainer, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	tween.tween_callback($GUI/Control/MarginContainer.hide)
	tween.tween_property($GUI/Control/Login, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
#func _on_options_pressed() -> void:
#	player.anim("Wave")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_registro_pressed() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(%Login, "modulate", Color.TRANSPARENT, 1.0)
	tween.tween_callback(%Login.hide)
	tween.tween_callback(%Register.show)
	tween.tween_property(%Register, "modulate", Color.WHITE, 1.0)
