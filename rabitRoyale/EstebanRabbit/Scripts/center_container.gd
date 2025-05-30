@tool
extends CenterContainer

@export var dot_radius : float = 5.0
@export var dot_color : Color = Color.WHITE
@export var player : Player

func _draw() -> void:
	draw_circle(Vector2.ZERO, dot_radius, dot_color)
	
func _ready() -> void:
	if not player.is_multiplayer_authority():
		queue_free()
		return
	queue_redraw()
