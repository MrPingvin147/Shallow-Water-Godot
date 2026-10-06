@abstract
extends Node2D
class_name BaseLevel

# Should return the global default spawn location
@abstract
func get_player_default_spawn() -> Vector2

@abstract
func get_player_camera() -> Camera2D
