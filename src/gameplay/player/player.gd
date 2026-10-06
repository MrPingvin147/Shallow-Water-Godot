@icon("res://assets/art/icon.png")

extends CharacterBody2D
class_name Player

# The Player is the root of the player entity.
# It owns the CharacterBody2D physics and delegates to component controllers.

# Component references
var movement_controller: MovementController
var combat_controller: CombatController
var health_controller: HealthController

func is_player_on_floor() -> bool:
	return is_on_floor()

func set_player_velocity(target_velocity: Vector2) -> void:
	velocity = target_velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_components()

func _init_components() -> void:
	# Find and store references to child controllers
	movement_controller = $MovementController as MovementController
	combat_controller = $CombatController as CombatController
	health_controller = $HealthController as HealthController

	# Connect health death signal
	if health_controller:
		health_controller.player_died.connect(_on_player_died)

# Called every physics frame.
# Player owns the physics loop and delegates to the movement controller.
func _physics_process(delta: float) -> void:

	var new_velocity = movement_controller.update(velocity, is_player_on_floor(), delta)
	
	velocity = new_velocity
	move_and_slide()

# Called when the player dies.
func _on_player_died() -> void:
	velocity = Vector2.ZERO
	# TODO: trigger death animation / respawn logic
