extends Enemy

var rng = RandomNumberGenerator.new()

@export var launch_force = 100.0

func attack():
	if rng.randf() >= 0.5:
		stab_attack()
	else:
		launch_attack()
	pass

func launch_attack():
	enemy_animator.play("Launch_attack")
	pass

# Function is called through EnemyAnimator
func launch():
	velocity.x = launch_force * current_direction

func stab_attack():
	enemy_animator.play("Stab_attack")
	pass
