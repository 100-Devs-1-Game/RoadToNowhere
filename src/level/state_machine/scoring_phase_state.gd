class_name ScoringPhaseState
extends StateMachineState

const SCORE_DISPLAY_INTERVAL= 0.5

var score: int



func on_enter():
	score_city()


func score_city():
	score= 0
	
	var city: City= Global.city

	var road_access_dict: Dictionary
	for tile_pos in city.get_road_tiles():
		#FloatingText.add(origin + city.get_position_from_tile(tile), "+1", 2.0, Color.GREEN, 30, false, true)
		var road: PlaceableTile= city.get_road(tile_pos)
		
		if road.auto_scores:
			trigger_score(tile_pos, 1)
		
		road.run_custom_scoring(self, tile_pos)
		
		for pos in Utils.get_neighbor_tiles(tile_pos, false): 
			road_access_dict[pos]= true
		
		for connection: Vector2i in city.get_road_connections(tile_pos):
			var connected_road_pos: Vector2i= tile_pos + connection
			if connected_road_pos not in city.get_road_tiles() or -connection not in city.get_road_connections(connected_road_pos):
				#FloatingText.add(origin + city.get_position_from_tile(tile) + Vector2(connection) * 32, "-1", 2.0, Color.RED, 30, false, true)
				trigger_score(tile_pos, -1, Vector2(connection) * 32)
		
		await get_tree().create_timer(SCORE_DISPLAY_INTERVAL).timeout

	for tile_pos in city.get_building_tiles():
		var building: BuildingTile= city.get_building(tile_pos)

		if road_access_dict.has(tile_pos):
			#FloatingText.add(origin + city.get_position_from_tile(tile), "+5", 2.0, Color.GREEN, 30, false, true)
			trigger_score(tile_pos, 1)

		building.run_custom_scoring(self, tile_pos)

		await get_tree().create_timer(SCORE_DISPLAY_INTERVAL).timeout

	Player.update_level_score(score)


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
