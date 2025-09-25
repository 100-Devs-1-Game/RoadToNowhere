class_name ActionFellTree
extends BaseAction

@export var tree_tile: ObjectTile



func can_execute(tile_pos: Vector2i)-> bool:
	var object: ObjectTile= Global.city.get_object(tile_pos)
	return object == tree_tile


func execute(tile_pos: Vector2i):
	Global.city.remove_object(tile_pos)
