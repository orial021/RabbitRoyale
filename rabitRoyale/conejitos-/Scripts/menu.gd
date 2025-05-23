extends Node3D

@onready var door_create: Node3D = $settings/Doorcreate
@onready var door_join: Node3D = $settings/Doorjoin
@onready var player: CharacterMenu = $Character_menu
var enterGame : bool = false

func _ready() -> void:
	ResourceLoader.load_threaded_request("res://scenes/level.tscn")

func _process(delta: float) -> void:
	if not enterGame:
		pass
	else:
		var scene_load_status = ResourceLoader.load_threaded_get_status("res://scenes/level.tscn")
		if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().call_deferred("change_scene_to_packed", ResourceLoader.load_threaded_get("res://scenes/level.tscn"))
			
			

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterMenu:
		print("entrando")
		Global.player_type = "host"
		enterGame = true


func _on_enter_pressed() -> void:
	door_create.open()
	door_join.open()
	$Character_menu.anim("wave")
	var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property($GUI/Control/MarginContainer, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property($GUI/Control/MarginContainer, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	tween.tween_callback($GUI/Control/MarginContainer.hide)
	tween.tween_property(%login, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_register_pressed() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(%login, "modulate", Color.TRANSPARENT, 1.0)
	tween.tween_callback(%login.hide)
	tween.tween_callback(%register.show)
	tween.tween_property(%register, "modulate", Color.WHITE, 1.0)




func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body is CharacterMenu:
		Global.player_type = "client"
		enterGame = true 
