# (optional) icon to show in the editor dialogs:
@icon("res://Shallow water art/Icon.png")

# Inheritance:
extends CharacterBody2D
class_name PlayerController

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var combat_controller: CombatController = $CombatController
@onready var health_controller: HealthController = $HealthController

@export_group("Stats")
@export var speed: int = 600
@export var jump_force: int = -500
@export var gravity: float = 9.81
@export var dash_time: float = 1.5
@export var dash_speed: int = 800
@export var coyote_time: float = 0.2
@export var jump_buffer_time: float = 0.2

var current_direction = -1
var m_move_direction := 0.0

var dashing := false
var current_dash_time := 0.0
var can_dash := true

var current_coyote_time := -1.0
var current_jump_buffer_time := -1.0
var can_jump := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	get_input()
	tjek_collisions()
	
	if !dashing:
		handle_movement()
		handle_rotation()
		handle_jump()
	else:
		handle_dash()
	
	handle_animation()
	
	move_and_slide()
	pass;

func tjek_collisions():
	if is_on_floor():
		can_dash = true
		can_jump = true

func handle_animation():	
	if dashing:
		player_sprite.play("Dash")
		
	elif get_real_velocity().y  > 50 || get_real_velocity().y  > -40 && player_sprite.animation == "Jumping":
		if player_sprite.animation == "Jumping":
			var last_anim_index = player_sprite.frame
			player_sprite.play("Falling")
			player_sprite.set_frame_and_progress(player_sprite.sprite_frames.get_frame_count("Falling") - 1 - last_anim_index,0)
		else:
			play_one_shot("Falling")
		
	elif get_real_velocity().y  < -50:
		play_one_shot("Jumping")
		
	elif abs(m_move_direction) > 0:
		player_sprite.play("Walk",m_move_direction)
		
	else:
		player_sprite.play("Idle")

func play_one_shot(anim_name: StringName, custom_speed: float = 1.0, from_end: bool = false):
	if player_sprite.frame != player_sprite.sprite_frames.get_frame_count(anim_name) - 1:
		player_sprite.play(anim_name,custom_speed,from_end)

func handle_rotation():
	if m_move_direction > 0:
		flip(1)
		current_direction = 1
	elif m_move_direction < 0:
		flip(-1)
		current_direction = -1
	
	
func flip(direction):
	if current_direction != direction:
		scale.x *= -1

func handle_movement():
	velocity.x = m_move_direction * speed
	
	if !is_on_floor():
		velocity.y += gravity

func handle_dash():
	current_dash_time -= get_process_delta_time()
	
	if current_dash_time > 0:
		velocity.x = dash_speed * current_direction
	
	if current_dash_time < 0:
		dashing = false

func dash():
	if can_dash:
		dashing = true
		can_dash = false
		current_dash_time = dash_time
		velocity = Vector2.ZERO

func handle_jump():
	current_coyote_time -= get_process_delta_time()
	current_jump_buffer_time -= get_process_delta_time()
	
	if is_on_floor():
		current_coyote_time = coyote_time
	
	if current_coyote_time < 0 && current_jump_buffer_time < 0 && !is_on_floor():
		can_jump = false
	
	if current_jump_buffer_time > 0 && can_jump:
		perform_jump()

func perform_jump():
	velocity.y = jump_force
	reset_jump_timers()
	can_jump = false

func reset_jump_timers():
	current_coyote_time = -1
	current_jump_buffer_time = -1

func jump():
	current_jump_buffer_time = jump_buffer_time
	
	if current_coyote_time > 0 && can_jump:
		perform_jump()

func cancel_jump():
	if get_real_velocity().y < 50:
		velocity.y = get_real_velocity().y / 3

#region HandleInput
func get_input():
	m_move_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_released("jump"):
		cancel_jump()
	if event.is_action_pressed("dash"):
		dash()
#endregion
