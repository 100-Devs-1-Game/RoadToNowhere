class_name City
extends Node2D

enum TileLayer { GROUND, BUILDINGS, OBJECTS, ROADS }

@export var tilemaps: Array[TileMapLayer]



func _ready() -> void:
	Global.city= self


func place_tile(tile_to_place: BaseTile, tile_pos: Vector2i, rotation: Vector2i= Vector2i.ZERO):
	var tilemap: TileMapLayer= get_tilemap(tile_to_place.target_tilemap)
	tilemap.set_cell(tile_pos, tile_to_place.source_id, Vector2i.ZERO)


func get_tilemap(type: TileLayer)-> TileMapLayer:
	return tilemaps[int(type)]


func get_mouse_tile()-> Vector2i:
	return get_tile_from_position(get_global_mouse_position())


func get_position_from_tile(tile: Vector2i)-> Vector2:
	return tilemaps[0].map_to_local(tile)


func get_tile_from_position(pos: Vector2)-> Vector2i:
	return tilemaps[0].local_to_map(pos)


func is_in_bounds(tile: Vector2i)-> bool:
	return true
