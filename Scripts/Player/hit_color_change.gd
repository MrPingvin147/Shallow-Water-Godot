extends Node2D


@export var color: Color
var old_color: Color
@export var anim_time = 0.2

func _on_entity_hit() -> void:
	old_color = self_modulate
	self_modulate = color
	
	await get_tree().create_timer(anim_time).timeout
	self_modulate = old_color
