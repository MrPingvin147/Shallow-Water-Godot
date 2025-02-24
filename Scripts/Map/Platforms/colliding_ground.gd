@tool
extends Node2D

@onready var sprite := $Sprite
@export var ground_collider: CollisionShape2D
@export var wall_collider: CollisionShape2D

enum PlatformType {
	TOP,
	TOPRIGHT,
	RIGHT
}

@export_category("Tool")
@export var platform_type: PlatformType:
	set(new_type):
		platform_type = new_type
		_on_platform_set()

@export var turn_h: bool = false:
	set(value):
		turn_h = value
		_on_turn_h()

@export var turn_v: bool = false:
	set(value):
		turn_v = value
		_on_turn_v()

@export_category("Spawn Platform")
@export var spawn_offset := Vector2.ZERO

@export var spawn_platform_type: PlatformType

@export var place_left: bool:
	set(value):
		place_platform(0)
		place_left = false

@export var place_right: bool:
	set(value):
		place_platform(1)
		place_right = false

@export var place_up: bool:
	set(value):
		place_platform(2)
		place_up = false

@export var place_down: bool:
	set(value):
		place_platform(3)
		place_down = false

func _ready() -> void:
	rotation = 0
	_on_platform_set()
	_on_turn_h()
	_on_turn_v()

func _on_turn_h():
	if turn_h && scale.x == 1 || !turn_h && scale.x == -1:
		scale.x *= -1 

func _on_turn_v():
	if turn_v && scale.y == 1 || !turn_v && scale.y == -1:
		scale.y *= -1

func _on_platform_set():
	if sprite == null || ground_collider == null || wall_collider == null:
		return
	
	var sprite_paths: Array[String] = [
	"res://Shallow water art/Map/Platform/U Platform/U Platform.png",
	"res://Shallow water art/Map/Platform/U Platform ER/U_Platform_ER.png",
	"res://Shallow water art/Map/Platform/U Platform ERB/U Platform ERB.png"
	]
	
	# Size(x,y), position(x,y)
	var ground_collider_info: Array[Array] = [
		[Vector2(295,10),Vector2(0.5,-115)],
		[Vector2(295,10),Vector2(-5,-115)],
		[Vector2(0,0),Vector2(0,0)]
	]
	
	# Size(x,y), position(x,y)
	var wall_collider_info: Array[Array] = [
		[Vector2(0,0),Vector2(0.5,0)],
		[Vector2(295,260),Vector2(-5,20)],
		[Vector2(291,295),Vector2(-5,0.5)]
	]
	
	sprite.texture = load(sprite_paths[platform_type])
	
	var ground_shape := RectangleShape2D.new()
	var wall_shape := RectangleShape2D.new()
	
	if ground_collider_info[platform_type][0] == Vector2.ZERO:
		ground_collider.disabled = true
	else:
		ground_collider.disabled = false
	ground_shape.size = ground_collider_info[platform_type][0]
	ground_collider.shape = ground_shape
	ground_collider.position = ground_collider_info[platform_type][1]
	
	if wall_collider_info[platform_type][0] == Vector2.ZERO:
		wall_collider.disabled = true
	else:
		wall_collider.disabled = false
	wall_shape.size = wall_collider_info[platform_type][0]
	wall_collider.shape = wall_shape
	wall_collider.position = wall_collider_info[platform_type][1]

func place_platform(direction: int):
	if !Engine.is_editor_hint():
		return
	
	var parent = get_parent()
	
	if parent == null:
		return
	
	var platform_scene: PackedScene = preload("res://Scripts/Map/Platforms/colliding_ground.tscn")
	var placement: Array[Vector2] = [
		Vector2(-294,0),
		Vector2(294,0),
		Vector2(0,-294),
		Vector2(0,294)
	]
	
	# Create object in scene
	var platform := platform_scene.instantiate()
	parent.add_child(platform)
	platform.owner = get_tree().edited_scene_root
	
	# Change objects start settings
	platform.position = position + placement[direction] + spawn_offset
	platform.platform_type = spawn_platform_type
	platform.spawn_platform_type = spawn_platform_type
	var node_name: String
	
	match spawn_platform_type:
		PlatformType.TOP:
			node_name = "GTop"
		PlatformType.TOPRIGHT:
			node_name = "GTopRight"
		PlatformType.RIGHT:
			node_name = "GRight"
	
	platform.name = node_name
