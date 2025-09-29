class_name ScoringPhaseState
extends StateMachineState

class RoadNetwork:
	var tiles: Array[Vector2i]
	var buildings: Array[Vector2i]
	
	func add_tile(tile: Vector2i):
		tiles.append(tile)

	func add_building(tile: Vector2i):
		buildings.append(tile)

	func has_tile(tile: Vector2i)-> bool:
		return tile in tiles
	
	func has_building(tile: Vector2i)-> bool:
		return tile in buildings


const SCORE_DISPLAY_INTERVAL= 0.5

@onready var label_score: Label = $"CanvasLayer/Label Score"

var score: int
var road_networks: Array[RoadNetwork]



func on_enter():
	score_city()
	label_score.text= "0"
	label_score.show()


func on_exit():
	label_score.hide()


func score_city():
	road_networks.clear()
	flood_fill()
	
	score= 0
	
	var city: City= Global.city

	var road_access_dict: Dictionary
	for tile_pos in city.get_road_tiles():
		#FloatingText.add(origin + city.get_position_from_tile(tile), "+1", 2.0, Color.GREEN, 30, false, true)
		var road: PlaceableTile= city.get_road(tile_pos)
		
		if road.score > 0:
			trigger_score(tile_pos, road.score)
		
		road.run_custom_scoring(self, tile_pos)
		
		for pos in Utils.get_neighbor_tiles(tile_pos, false): 
			road_access_dict[pos]= true
		
		for connection: Vector2i in city.get_road_connections(tile_pos):
			var connected_road_pos: Vector2i= tile_pos + connection
			if connected_road_pos not in city.get_road_tiles() or -connection not in city.get_road_connections(connected_road_pos):
				trigger_score(tile_pos, -1, Vector2(connection) * 32)
		
		await get_tree().create_timer(SCORE_DISPLAY_INTERVAL).timeout

	for tile_pos in city.get_building_tiles():
		var building: BuildingTile= city.get_building(tile_pos)

		if building.road_access_scores and road_access_dict.has(tile_pos):
			trigger_score(tile_pos, 1)

		for neighbor in Utils.get_neighbor_tiles(tile_pos):
			for network in road_networks:
				if network.has_tile(neighbor):
					network.add_building(tile_pos)
		
		await get_tree().create_timer(SCORE_DISPLAY_INTERVAL).timeout

	for tile_pos in city.get_building_tiles():
		var building: BuildingTile= city.get_building(tile_pos)
		building.run_custom_scoring(self, tile_pos)


	Player.update_level_score(score)


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


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventKey:
		if event.keycode == KEY_F1 and OS.is_debug_build():
			score_city()


func trigger_score(tile: Vector2i, amount: int, offset: Vector2= Vector2.ZERO):
	assert(amount != 0)
	var city: City= Global.city
	#var origin: Vector2= city.get_global_canvas_transform()
	#origin.y-= 20
	
	var color:= Color.GREEN
	if amount < 0:
		color= Color.RED
	
	#var canvas_pos: Vector2= origin + city.get_position_from_tile(tile) + offset
	offset.y-= 20
	var canvas_pos: Vector2= city.get_canvas_transform() * ( city.get_position_from_tile(tile) + offset )
	
	FloatingText.add(canvas_pos, Utils.number_with_sign(amount), 2.0, color, 30, false, true)

	score+= amount
	label_score.text= str(score)
