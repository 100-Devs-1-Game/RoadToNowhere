class_name ScoringPhaseState
extends StateMachineState

class RoadNetwork:
	var tiles: Array[Vector2i]
	var buildings: Array[Vector2i]
	
	func add_tile(tile: Vector2i):
		assert(tile not in tiles)
		tiles.append(tile)

	func add_building(tile: Vector2i):
		if tile in buildings:
			return
		buildings.append(tile)

	func has_tile(tile: Vector2i)-> bool:
		return tile in tiles
	
	func has_building(tile: Vector2i)-> bool:
		return tile in buildings


const SCORE_DISPLAY_INTERVAL= 0.5

@onready var label_score: Label = $"CanvasLayer/Label Score"
@onready var tile_map_marker: TileMapLayer = $"TileMapLayer Tile Marker"

var score: int
var road_networks: Array[RoadNetwork]



func on_enter():
	score_city()
	label_score.text= "0"
	label_score.show()


func on_exit():
	label_score.hide()


func score_city():
	for button in Global.level.buttons:
		button.disabled= true

	road_networks.clear()
	flood_fill()
	
	score= 0
	
	var city: City= Global.city

	var road_access_dict: Dictionary
	var road_tiles:= city.get_road_tiles()
	road_tiles.sort_custom(sort_by_coordinates)
	for tile_pos in road_tiles:
		var road: PlaceableTile= city.get_road(tile_pos)
		var road_score:= 0
		
		if road.score > 0:
			#trigger_score(tile_pos, road.score)
			road_score+= road.score
			
		road_score+= road.run_custom_scoring(self, tile_pos, false)
		
		for pos in Utils.get_neighbor_tiles(tile_pos, false): 
			road_access_dict[pos]= true
		
		for connection: Vector2i in city.get_road_connections(tile_pos):
			var connected_road_pos: Vector2i= tile_pos + connection
			if connected_road_pos not in city.get_road_tiles() or -connection not in city.get_road_connections(connected_road_pos):
				#trigger_score(tile_pos, -1, Vector2(connection) * 32)
				road_score-= 1
		
		trigger_score(tile_pos, road_score)
		
		await get_tree().create_timer(SCORE_DISPLAY_INTERVAL).timeout

	var building_tiles: Array[Vector2i]
	building_tiles= city.get_building_tiles()
	building_tiles.sort_custom(sort_by_coordinates)
	for tile_pos in building_tiles:
		for neighbor in Utils.get_neighbor_tiles(tile_pos, false):
			for network in road_networks:
				if network.has_tile(neighbor):
					network.add_building(tile_pos)

	for tile_pos in building_tiles:
		var building: BuildingTile= city.get_building(tile_pos)

		if building.road_access_scores and road_access_dict.has(tile_pos):
			trigger_score(tile_pos, 1)
		else:
			building.run_custom_scoring(self, tile_pos)
		await get_tree().create_timer(SCORE_DISPLAY_INTERVAL).timeout

	var object_tiles: Array[Vector2i]
	object_tiles= city.get_dynamic_object_tiles()
	object_tiles.sort_custom(sort_by_coordinates)
	for tile_pos in object_tiles:
		var object: DynamicObjectTile= city.get_dynamic_object(tile_pos)
		if object.custom_scoring != BaseTile.CustomScoringAlgorithm.NONE:
			object.run_custom_scoring(self, tile_pos)
			await get_tree().create_timer(SCORE_DISPLAY_INTERVAL).timeout

	Player.update_level_score(score)

	Global.level.button_exit.disabled= false
	

func flood_fill():
	var city: City= Global.city
	
	for tile in city.get_road_tiles():
		var is_in_network: bool= false
		for network in road_networks:
			if network.has_tile(tile):
				is_in_network= true
		if is_in_network:
			continue
		
		var network:= RoadNetwork.new()
		road_networks.append(network)
		var new_tiles: Array[Vector2i]
		new_tiles.append(tile)
		
		while not new_tiles.is_empty():
			var new_tile: Vector2i= new_tiles.pop_front()
			assert(not network.has_tile(new_tile))
			network.add_tile(new_tile)
		
			for connection in city.get_road_connections(new_tile):
				var neighbor: Vector2i= new_tile + connection
				if network.has_tile(neighbor) or neighbor in new_tiles:
					continue
				assert(neighbor != tile)
				if neighbor in city.get_road_tiles() and -connection in city.get_road_connections(neighbor):
					new_tiles.append(neighbor)


func sort_by_coordinates(a: Vector2i, b: Vector2i):
	var width: int= Global.city.get_rect().size.x
	return a.y * width + a.x < b.y * width + b.x


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventKey:
		if event.keycode == KEY_F1 and OS.is_debug_build():
			score_city()


func trigger_score(tile: Vector2i, amount: int, offset: Vector2= Vector2.ZERO):
	var city: City= Global.city
	
	var color:= Color.GREEN
	if amount == 0:
		color= Color.YELLOW
	elif amount < 0:
		color= Color.RED
	
	offset.y-= 20
	var canvas_pos: Vector2= city.get_canvas_transform() * ( city.get_position_from_tile(tile) + offset )
	
	FloatingText.add(canvas_pos, Utils.number_with_sign(amount), 2.0, color, 30, false, true)

	var atlas_coords: Vector2i
	if amount == 0:
		atlas_coords= Vector2i(1, 0)
	elif amount < 0:
		atlas_coords= Vector2i(2, 0)
		AudioManager.play_sound("score_negative")
	else:
		AudioManager.play_sound("score_positive")
		
	tile_map_marker.set_cell(tile, 0, atlas_coords)

	score+= amount
	label_score.text= str(score)
