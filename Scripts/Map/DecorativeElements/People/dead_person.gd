@tool
extends Sprite2D

@export var sprite_index: int = 1:
	set(value):
		if value > 7:
			sprite_index = 1
		elif value < 1:
			sprite_index = 7
		else:
			sprite_index = value
		_on_sprite_changed(sprite_index)

func _on_sprite_changed(value):
	var base_image_path: String = "res://Shallow water art/Map/DeadPeople/dead_person_"
	
	texture = load(base_image_path + str(sprite_index) + ".png")
