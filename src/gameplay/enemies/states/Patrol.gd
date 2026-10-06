extends StateMachineBase

@export var detection_area: Area2D
@export var chase_check_ray: RayCast2D
@export var flip_ground_ray: RayCast2D
@export var flip_wall_ray: RayCast2D

@export var speed_multiplier := 1.0


func do_ready():
	detection_area.body_entered.connect(_on_detection_area_entered)
	flip_ground_ray.colliding.connect(_on_flip_ground_ray_colliding)
	flip_wall_ray.colliding.connect(_on_flip_wall_ray_colliding)

func on_state_enter():
	pass

func on_state_exit():
	pass

func do_process(_delta: float):
	if enemy.player != null:
		var target_position = enemy.player.position - enemy.position
		target_position.x *= enemy.current_direction  * -1
		chase_check_ray.target_position = target_position
		if !chase_check_ray.is_colliding():
			enemy.change_state(enemy.state_types.CHASE)
	pass

func do_physics_process(_delta: float):
	# Gravity
	if !enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity
	
	# Base movement
	enemy.velocity.x = enemy.base_speed * enemy.current_direction * speed_multiplier
	
	enemy.move_and_slide()

#region signals
func _on_flip_ground_ray_colliding(is_colliding: bool) -> void:
	if !is_colliding && enemy.is_on_floor():
		enemy.force_flip()

func _on_flip_wall_ray_colliding(is_colliding: bool) -> void:
	if is_colliding && enemy.is_on_floor():
		enemy.force_flip()

func _on_detection_area_entered(body: PlayerController):
	enemy.player = body
	enemy.change_state(enemy.state_types.CHASE)

#endregion
