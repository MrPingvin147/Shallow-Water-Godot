class_name PropBase
extends Node2D
## Base class for all map props (walls, decorations, interactive objects).

## Whether this prop can be interacted with
@export var can_interact: bool = false

## Text shown when the player hovers over this prop
@export var interact_prompt: String = ""

## Whether this prop blocks player movement
@export var blocks_movement: bool = false

## Called when the player interacts with this prop
func interact(_player: Node2D) -> void:
	pass
