extends Node2D
class_name HealthController

signal player_hit
signal player_died

@export var base_health := 10
@export var current_health := 10

func take_damage(damage: float, attacker: Node2D):
	if current_health - damage <= 0:
		die()
		return
	
	current_health -= damage
	player_hit.emit()
	print("Current health: ",current_health)

func die():
	player_died.emit()
	print("Player died")
	pass
