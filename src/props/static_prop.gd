class_name StaticProp
extends PropBase
## A non-interactive physical prop (wall, pillar, crate, etc.)
## Typically used with StaticBody2D for collision.

@export_group("Collision")
@export var collision_layer: int = 1 << 4  # Wall layer
@export var collision_mask: int = 0

func _ready() -> void:
	if has_node("CollisionShape2D"):
		var col := $CollisionShape2D as CollisionShape2D
		if col.shape:
			col.shape.radius = col.shape.radius  # force re-eval
