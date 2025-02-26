extends StateMachineBase

@export var chase_area: Area2D
@export var attack_area: Area2D
@export var chase_check_ray: RayCast2D

@export var speed_multiplier := 1.0
var current_speed_multiplier: float

func do_ready():
	chase_area.body_exited.connect(_on_chase_area_exited)
	attack_area.body_entered.connect(_on_attack_area_entered)

func on_state_enter():
	current_speed_multiplier = speed_multiplier
	pass

func on_state_exit():
	pass

func do_process(_delta: float):
	var target_position = enemy.player.position - enemy.position
	target_position.x *= enemy.current_direction * -1
	chase_check_ray.target_position = target_position
	if chase_check_ray.is_colliding():
		enemy.change_state(enemy.state_types.PATROL)
	pass

func do_physics_process(_delta: float):
	if !enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity
	
	var distance = enemy.global_position.x - enemy.player.global_position.x
	if abs(distance) < 5:
		current_speed_multiplier = 0
	elif distance > 0:
		enemy.set_direction(-1)
		current_speed_multiplier = speed_multiplier
	elif distance < 0:
		enemy.set_direction(1)
		current_speed_multiplier = speed_multiplier
	
	enemy.velocity.x = abs(enemy.base_speed * current_speed_multiplier) * enemy.current_direction
	
	enemy.move_and_slide()

func _on_chase_area_exited(_body: Node2D):
	enemy.player = null
	enemy.change_state(enemy.state_types.PATROL)

func _on_attack_area_entered(_body: Node2D):
	enemy.change_state(enemy.state_types.ATTACK)
