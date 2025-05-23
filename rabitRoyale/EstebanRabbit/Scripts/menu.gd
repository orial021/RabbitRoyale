extends Node3D
@onready var  door_create: Node3D = $Settings/DoorCreate
@onready var door_join: Node3D = $Settings/DoorJoin
@onready var player: Charactermenu  = $Character_menu
var enterGame : bool = false


func _ready() -> void:
	ResourceLoader.load_threaded_get("res://Scenes/level.tscn")

func _process(delta: float) -> void:
	if not enterGame:
		pass
	else:
		var scene_loas_status = ResourceLoader.load_threaded_get("res://Scenes/level.tscn")
		if scene_loas_status == ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().call_deferred("change_scene_to_packed", ResourceLoader.load_threaded_get("res://Scenes/level.tscn"))


func _on_area_3d_body_entered(body: Node3D) -> void:
	if  body is Charactermenu:
		enterGame = true
		Global.player_type = "host"



func _on_area_join_entered(body: Node3D) -> void:
	if  body is Charactermenu:
		enterGame = true
		Global.player_type = "client"
	
func _on_enter_pressed() -> void:
	door_create.open()
	door_join.open()
	$Character_menu.anin("Wave")
	var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property($GUI/Control/MarginContainer, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property($GUI/Control/MarginContainer, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	tween.tween_callback($GUI/Control/MarginContainer.hide)
	tween.tween_property(%login, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)


func _on_options_pressed() -> void:
	pass # Replace with function body.



func _on_exit_pressed() -> void:
	get_tree().quit()



func _on_register_pressed() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(%login, "modulate", Color.TRANSPARENT, 1.0)
	tween.tween_callback(%login.hide)
	tween.tween_callback(%Register.show)
	tween.tween_property(%Register, "modulate", Color.WHITE, 1.0)
