class_name Interactable
extends PropBase
## Base class for props the player can interact with (levers, chests, doors).

@export_group("Interaction")
@export var requires_item: String = ""
@export var cooldown: float = 1.0
@export var one_time_only: bool = false

@onready var _can_interact: bool = true

func _ready() -> void:
	can_interact = true

func try_interact(player: Node2D) -> void:
	if not _can_interact:
		return
	if not can_interact:
		return
	if requires_item and not player.has_item(requires_item):
		return
	interact(player)
	if one_time_only:
		can_interact = false
		queue_free()
	elif cooldown > 0:
		_can_interact = false
		await get_tree().create_timer(cooldown).timeout
		_can_interact = true
