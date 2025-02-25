extends StateMachineBase

@export var anim_sprite: AnimatedSprite2D

@export var damage := 1

func do_ready():
	pass

func on_state_enter():
	anim_sprite.play("Attack")
	pass

func on_state_exit():
	pass

func do_process(_delta: float):
	pass

func do_physics_process(_delta: float):
	pass
