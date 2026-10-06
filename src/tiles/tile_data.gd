class_name TileData
extends Resource
## Custom data that can be attached to specific tiles in a TileMapLayer.

@export_group("Tile Properties")
@export var is_solid: bool = false
@export var is_water: bool = false
@export var is_destructible: bool = false
@export var destructible_health: int = 1
@export var drop_item: String = ""
@export var spawn_particles: bool = false
