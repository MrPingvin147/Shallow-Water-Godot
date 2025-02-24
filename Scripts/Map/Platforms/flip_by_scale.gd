@tool
extends StaticBody2D

@export var turn_h: bool = false:
	set(value):
		turn_h = value
		_on_turn_h()

@export var turn_v: bool = false:
	set(value):
		turn_v = value
		_on_turn_v()

func _on_turn_h():
	if turn_h && scale.x == 1 || !turn_h && scale.x == -1:
		scale.x *= -1 

func _on_turn_v():
	if turn_v && scale.y == 1 || !turn_v && scale.y == -1:
		scale.y *= -1
