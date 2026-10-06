extends StateMachineBase

@export var damage := 1

func do_ready():
	pass

func on_state_enter():
	enemy.player.health_controller.take_damage(damage, enemy)
	enemy.change_state(enemy.state_types.CHASE)
	pass

func on_state_exit():
	pass

func do_process(_delta: float):
	pass

func do_physics_process(_delta: float):
	pass
