extends Node2D
class_name HealthController

@export var base_health := 10
@export var current_health := 10

func take_damage(damage: float, attacker: Node2D):
	if current_health - damage <= 0:
		die()
		return
	
	current_health -= damage
	print("Current health: ",current_health)

func die():
	print("Player died")
	pass
