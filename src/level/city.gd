class_name City
extends Node2D

enum TileLayer { GROUND, BUILDINGS, OBJECTS, ROADS }

@export var tilemaps: Array[TileMapLayer]
@export var asphalt_tile: FloorTile

var road_connections: Dictionary



func _ready() -> void:
	Global.city= self


func place_tile(tile_to_place: BaseTile, tile_pos: Vector2i, tile_rot: float= 0.0):
	var target_tilemap: TileLayer= tile_to_place.target_tilemap
	var tilemap: TileMapLayer= get_tilemap(target_tilemap)
	
	prints("Tile rot", tile_rot)
	tile_rot= wrapf(tile_rot, 0.0, 2 * PI)
	prints("Tile rot wrapped", tile_rot)
	
	var tile_alternate: int= 0
	var tile_rot_deg: int= round(rad_to_deg(tile_rot))
	prints("Tile rot deg", tile_rot_deg)

	match int(tile_rot_deg):
		90:
			tile_alternate= TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H
		180:
			tile_alternate= TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V
		270:
			tile_alternate= TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V

	tilemap.set_cell(tile_pos, tile_to_place.source_id, Vector2i.ZERO, tile_alternate)

	if target_tilemap == TileLayer.BUILDINGS or target_tilemap == TileLayer.ROADS:
		place_tile(asphalt_tile, tile_pos)
		if target_tilemap == TileLayer.BUILDINGS:
			for neighbor_pos in get_neighbor_tiles(tile_pos):
				if is_water_tile(neighbor_pos):
					continue
				place_tile(asphalt_tile, neighbor_pos)
		elif target_tilemap == TileLayer.ROADS:
			assert(tile_to_place is PlaceableTile)
			var road: PlaceableTile= tile_to_place
			for connection in road.road_connections:
				if not road_connections.has(tile_pos):
					road_connections[tile_pos]= []
				prints("rot", tile_rot)
				prints("from", connection)
				var vec_rot: Vector2= Vector2(connection).rotated(tile_rot)
				prints("to vec2 rotated", vec_rot)
				var rotated_connection: Vector2i= vec_rot.round()
				prints("Connection", rotated_connection)
				road_connections[tile_pos].append(rotated_connection)


func get_tilemap(type: TileLayer)-> TileMapLayer:
	return tilemaps[int(type)]


func get_mouse_tile()-> Vector2i:
	return get_tile_from_position(get_global_mouse_position())


func get_position_from_tile(tile: Vector2i)-> Vector2:
	return tilemaps[0].map_to_local(tile)


func get_tile_from_position(pos: Vector2)-> Vector2i:
	return tilemaps[0].local_to_map(pos)


func get_neighbor_tiles(center: Vector2i, include_center: bool= false)-> Array[Vector2i]:
	var result: Array[Vector2i]
	for x in range(-1, 2):
		for y in range(-1, 2):
			var neighbor:= center + Vector2i(x, y)
			if not is_in_bounds(neighbor):
				continue
			if include_center or neighbor != center:
				result.append(neighbor)
	
	return result


func get_floor_tile(tile_pos: Vector2i)-> FloorTile:
	var source_id: int= get_source_id(tile_pos, TileLayer.GROUND)
	if source_id == -1:
		return null
	return GameData.source_id_to_ground_tile[source_id]


func get_source_id(tile: Vector2i, tile_layer: TileLayer)-> int:
	var tile_map: TileMapLayer= get_tilemap(tile_layer)
	return tile_map.get_cell_source_id(tile)


func get_road_connections(tile: Vector2i)-> Array:
	if not road_connections.has(tile):
		return []
	return road_connections[tile]

func is_water_tile(tile: Vector2i)-> bool:
	var floor_tile: FloorTile= get_floor_tile(tile)
	if not floor_tile:
		return false
	return floor_tile.is_water


func is_in_bounds(tile: Vector2i)-> bool:
	return tile in tilemaps[0].get_used_cells()
