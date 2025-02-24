extends RayCast2D

signal colliding(is_colliding: bool)

func _physics_process(_delta: float) -> void:
	colliding.emit(is_colliding())
