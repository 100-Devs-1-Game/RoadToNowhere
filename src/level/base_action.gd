class_name BaseAction
extends Resource

@export var display_name: String
@export var icon: Texture



func can_execute(tile_pos: Vector2i)-> bool:
	assert(false, "Abstract function")
	return false

func execute(tile_pos: Vector2i):
	assert(false, "Abstract function")
