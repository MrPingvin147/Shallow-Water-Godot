class_name DecorativeProp
extends PropBase
## A purely visual prop with no collision (chain, lantern, sign, etc.)

@export_group("Visual")
@export var z_index: int = 0
@export var visible_when_far: bool = false

func _ready() -> void:
	z_index = z_index
