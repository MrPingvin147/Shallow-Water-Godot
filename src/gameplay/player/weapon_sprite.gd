extends AnimatedSprite2D

func _on_combat_controller_player_attacked() -> void:
	play("Attack")

func _on_animation_finished() -> void:
	play("Empty")
