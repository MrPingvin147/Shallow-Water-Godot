extends Node

# Main entrypoint for the game.
# Responsible for setting up the world and coordinating high level systems.

const TEST_LEVEL_SCENE_UID: String = "uid://bo32fm4sme3qu"
const PLAYER_SCENE_UID: String = "uid://lhoebnpkaq6p"

var player: Player = null

var _current_level: BaseLevel = null


# Game world root nodes.
@onready var level_root: Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot

# UI root nodes
@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_player()
	
	load_level(TEST_LEVEL_SCENE_UID)

# Instantiate the player and adds it to the entity root layer
func _init_player() -> void:
	var player_scene: PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	
	if player_scene == null:
		push_error("Player scene failed to load " + PLAYER_SCENE_UID)
		return
	
	player = player_scene.instantiate() as Player
	
	if player == null:
		push_error("Loaded player scene does not extend Player: " + PLAYER_SCENE_UID)
		return

	entity_root.add_child(player)

# Instantiate the current level and add it to the level root layer
func load_level(level_scene: String) -> void:
	_deferred_load_level.call_deferred(level_scene)

func _deferred_load_level(level_scene_uid: String) -> void:
	if _current_level != null:
		_current_level.queue_free()
		_current_level = null

	# Allow old level to finish freeing before adding new one
	await get_tree().process_frame

	var new_level_packed: PackedScene = ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene

	if new_level_packed == null:
		push_error("Could not load level as a packed scene: " + level_scene_uid)
		return
	
	_current_level = new_level_packed.instantiate() as BaseLevel

	if _current_level == null:
		push_error("Loaded scene is not of type BaseLevel: " + level_scene_uid)
		# TODO: Add default fallback scene (main menu)
		return

	level_root.add_child(_current_level)

	# Let the new level fully process before accessing
	await get_tree().process_frame

	_place_player_at_level_spawn()
	_setup_level_camera()


# Moves player to default player spawn location
func _place_player_at_level_spawn():
	if player == null:
		push_error("Cannot place player in level is null")
		return

	if _current_level == null:
		push_error("Cannot player in level because level is null")

	player.global_position = _current_level.get_player_default_spawn()


func _setup_level_camera():
	if player == null or _current_level == null:
		return

	var level_camera: Camera2D = _current_level.get_player_camera()

	if level_camera == null:
		push_error("Could not setup player camera current level returned null")
		return

	# TODO: Set up camera system and call camera_system.set_target(player)
	# level_camera.target = player
