extends Node2D
class_name MovementController

@export_group("Stats")
@export var speed: int = 600
@export var jump_force: int = -500
@export var gravity: float = 9.81
@export var dash_time: float = 1.5
@export var dash_speed: int = 800
@export var coyote_time: float = 0.2
@export var jump_buffer_time: float = 0.2

var target_velocity := Vector2.ZERO
var current_velocity := Vector2.ZERO

# State
var current_direction: int = -1
var m_move_direction := 0.0

var dashing := false
var current_dash_time := 0.0
var can_dash := true

var current_coyote_time := -1.0
var current_jump_buffer_time := -1.0
var can_jump := true

var is_on_floor: bool = false

# Called by Player._physics_process each frame.
func update(velocity: Vector2, is_player_on_floor, _delta: float) -> Vector2:
	current_velocity = velocity
	is_on_floor = is_player_on_floor

	if is_on_floor:
		can_dash = true
		can_jump = true
	
	get_input()
	
	if not dashing:
		handle_movement()
		handle_rotation()
		handle_jump()
	else:
		handle_dash()
	
	return target_velocity

# ---- Input ----

func get_input() -> void:
	m_move_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_released("jump"):
		cancel_jump()
	if event.is_action_pressed("dash"):
		dash()

# ---- Movement ----

func handle_movement() -> void:
	target_velocity.x = m_move_direction * speed

func handle_dash() -> void:
	current_dash_time -= get_process_delta_time()
	
	if current_dash_time > 0:
		target_velocity.x = dash_speed * current_direction
	
	if current_dash_time <= 0:
		dashing = false

func dash() -> void:
	if can_dash:
		dashing = true
		can_dash = false
		current_dash_time = dash_time
		target_velocity = Vector2.ZERO

# ---- Jump ----

func handle_jump() -> void:
	current_coyote_time -= get_process_delta_time()
	current_jump_buffer_time -= get_process_delta_time()
	
	if is_on_floor:
		current_coyote_time = coyote_time
	
	if current_coyote_time < 0 and current_jump_buffer_time < 0 and not is_on_floor:
		can_jump = false
	
	if current_jump_buffer_time > 0 and can_jump:
		perform_jump()

func perform_jump() -> void:
	target_velocity.y = jump_force
	reset_jump_timers()
	can_jump = false

func reset_jump_timers() -> void:
	current_coyote_time = -1
	current_jump_buffer_time = -1

func jump() -> void:
	current_jump_buffer_time = jump_buffer_time
	
	if current_coyote_time > 0 and can_jump:
		perform_jump()

func cancel_jump() -> void:
	if current_velocity.y < 50:
		target_velocity.y = current_velocity.y / 3

# ---- Rotation ----

func handle_rotation() -> void:
	if m_move_direction > 0:
		current_direction = 1
	elif m_move_direction < 0:
		current_direction = -1
