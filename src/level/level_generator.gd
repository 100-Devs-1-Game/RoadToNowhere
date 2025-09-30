class_name LevelGenerator
extends Node

@export var seed: int
@export var size:= Vector2i(10, 10)
@export var difficulty: int

@export_category("Tiles")
@export var grass_tile: FloorTile
@export var swamp_tile: FloorTile
@export var asphalt_tile: FloorTile
@export var river_tile: FloorTile
@export var tree_tile: ObjectTile

@export var house_tile: BuildingTile
@export var factory_tile: BuildingTile
@export var car_tile: DynamicObjectTile
@export var protestor_tile: DynamicObjectTile



func _ready() -> void:
	await get_parent().ready
	generate_city()


func generate_city():
	var city: City= Global.city
	var rng:= RandomNumberGenerator.new()
	rng.seed= seed

	prints("Level Seed", seed)

	for x in size.x:
		for y in size.y:
			var tile:= Vector2i(x, y) - Vector2i.ONE * size / 2
			if RngUtils.chance100_rng(difficulty, rng):
				city.place_tile(swamp_tile, tile)
			else:
				city.place_tile(grass_tile, tile) 

	for i in RngUtils.multi_chance100_rng(difficulty * 20, rng):
		if RngUtils.chance100_rng(50, rng):
			var x= randi() % size.x
			for y in size.y:
				var pos:= Vector2i(x, y) - Vector2i.ONE * size / 2
				if city.get_floor_tile(pos) and city.get_floor_tile(pos).is_water:
					break
				city.place_tile(river_tile, pos)
		else:
			var y= randi() % size.y
			for x in size.x:
				var pos:= Vector2i(x, y) - Vector2i.ONE * size / 2
				if city.get_floor_tile(pos) and city.get_floor_tile(pos).is_water:
					break
				city.place_tile(river_tile, pos, PI / 2)

	for x in size.x:
		for y in size.y:
			var tile:= Vector2i(x, y) - Vector2i.ONE * size / 2
			if RngUtils.chance100_rng(5, rng):
				city.place_tile(house_tile, tile)
			elif RngUtils.chance100_rng(1, rng):
				city.place_tile(factory_tile, tile)
				
	for x in size.x:
		for y in size.y:
			var tile:= Vector2i(x, y) - Vector2i.ONE * size / 2
			if not city.is_empty(tile, [grass_tile]):
				continue
			if RngUtils.chance100_rng(difficulty, rng):
				city.place_tile(tree_tile, tile)
			elif RngUtils.chance100_rng((difficulty - 5) / 2.0, rng):
				city.place_tile(protestor_tile, tile)
			elif RngUtils.chance100_rng(2, rng):
				city.place_tile(car_tile, tile)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed(): return
	if not OS.is_debug_build(): return
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			seed+= 1
			for layer in City.TileLayer.values():
				Global.city.get_tilemap(layer).clear()
			generate_city()
