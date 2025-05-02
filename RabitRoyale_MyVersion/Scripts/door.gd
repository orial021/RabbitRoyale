extends Node3D
@export var label:String 
@export var open_degree:float=1.7
func _ready() -> void:
	$Label3D.text=label
	
func open()->void:
	var tween: Tween=create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Door, "rotation",Vector3(0,open_degree,0),1.0)
	
