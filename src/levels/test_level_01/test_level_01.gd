extends BaseLevel

@export var player_camera: Camera2D
@export var player_spawn_locations: Array[Marker2D]

var _current_spawn_location: int = 0

func get_player_default_spawn() -> Vector2:
	if player_spawn_locations.size() == 0:
		printerr("No player spawn locations")
		return Vector2(0,0)

	return player_spawn_locations[0].global_position

func get_player_camera() -> Camera2D:
	return player_camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
