extends CharacterBody2D
class_name Enemy

@export var sprite: CanvasItem
var player: PlayerController

@export_category("States")
enum state_types{
	PATROL = 0,
	CHASE = 1,
	ATTACK = 2
}

@export var states: Array[StateMachineBase]
@export var current_state: StateMachineBase


@export_group("Stats")
@export var base_speed: int = 600
@export var gravity: float = 90
@export var max_health: int = 100
@export var current_health: float

@export_group("Anim")
@export var damage_anim_time := 0.1
@export var current_damage_anim_time: float
var current_direction = -1

func _ready() -> void:
	assert(states.size() > 0, "No State has been entered")
	current_health = max_health
	
	change_state(state_types.PATROL)
	
	for i in range(states.size()):
		states[i].enemy = self
		states[i].do_ready()
	
	current_damage_anim_time = damage_anim_time

func _process(delta: float) -> void:
	if current_state == null:
		return
	
	current_state.do_process(delta)
	
	current_damage_anim_time += get_process_delta_time()
	
	if current_damage_anim_time > damage_anim_time:
		sprite.self_modulate = Color(1,1,1)

func _physics_process(delta: float) -> void:
	if current_state == null:
		return
	
	current_state.do_physics_process(delta)

func take_damage(damage: int):
	trigger_damage_anim()
	
	if (current_health - damage <= 0):
		die()
		return
	current_health -= damage
	print(name, " health: ", current_health)

func trigger_damage_anim():
	sprite.self_modulate = Color(1,0.4,0.4,1)
	current_damage_anim_time = 0

func die():
	print(name + " has died")
	queue_free()

func force_flip():
	current_direction *= -1
	scale.x *= -1

func set_direction(direction: int):
	if current_direction != direction:
		force_flip()

func change_state(new_state: state_types):
	if current_state != null:
		current_state.on_state_exit()
	current_state = states[new_state]
	current_state.on_state_enter()

func _on_player_created(pl: PlayerController):
	player = pl
