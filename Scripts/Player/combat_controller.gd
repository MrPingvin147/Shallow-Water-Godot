extends Node2D
class_name CombatController

@export var base_damage := 20
@export var attack_cooldown := 0.1
@export var current_attack_cooldown: float

@export var attack_area: Area2D

func _ready() -> void:
	attack_area.monitoring = false
	current_attack_cooldown = attack_cooldown

func _physics_process(_delta: float) -> void:
	current_attack_cooldown += get_process_delta_time()
	
	if current_attack_cooldown > attack_cooldown:
		attack_area.monitoring = false

func attack():
	if (attack_area.monitoring == true):
		return
	attack_area.monitoring = true
	current_attack_cooldown = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()

# React to enemy body entering attack area and call take_damage
func _on_attack_area_body_entered(body: Node2D) -> void:
	body.take_damage(base_damage)
	attack_area.monitoring = false
