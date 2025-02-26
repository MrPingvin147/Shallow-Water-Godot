extends StateMachineBase

@export var weapon_area: Area2D
@export var anim_player: AnimationPlayer

@export var damage := 1   

func do_ready():
	anim_player.connect("animation_finished",_on_animation_finished)
	weapon_area.connect("body_entered",_on_body_entered)
	pass

func on_state_enter():
	enemy.velocity.x = 0
	pass

func on_state_exit():
	pass

func do_process(_delta: float):
	pass

func do_physics_process(_delta: float):
	if !enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity
	
	enemy.move_and_slide()
	pass

func _on_body_entered(_body: Node2D):
	enemy.player.health_controller.take_damage(damage,enemy)
	pass

func _on_animation_finished(anim_name: String):
	if anim_name == "Attack":
		enemy.change_state(enemy.state_types.CHASE)
	else:
		printerr("Animation that finished wasn't Attack as expected")
