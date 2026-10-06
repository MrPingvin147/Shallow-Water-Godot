class_name TilesetManager
extends Node
## Manages tileset loading and tile data registration.

@onready var tile_data: TileData = preload("res://src/tiles/tile_data.gd")

func register_tile_properties(tile_set: TileSet, tile_data_map: Dictionary) -> void:
	"""
	tile_data_map: { (atlas_coords, source_id): TileData }
	"""
	for key in tile_data_map:
		var coords := key as Vector2i
		var data := tile_data_map[key] as TileData
		tile_set.set_tile_data(coords, 0, data)
