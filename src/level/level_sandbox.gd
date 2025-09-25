extends Node

@export var generate_random_deck: bool= false
@export var card_pool: Array[CardData]
@export var min_deck_factor: int= 2
@export var max_deck_factor: int= 5

@export var generate_random_city: bool= false

@onready var level: Level= get_parent()



func _ready() -> void:
	await get_parent().ready
	
	if generate_random_city:
		generate_city()

	if generate_random_deck:
		generate_deck()


func generate_deck():
	var size:= card_pool.size()
	var deck:= Deck.new()
	for i in randi_range(size * min_deck_factor, size * max_deck_factor):
		var card_data: CardData= card_pool.pick_random()
		deck.add_card(card_data)
		card_data.unlocked= true
	
	level.deck= deck
	level.build_deck()

func generate_city():
	var city: City= Global.city

	var grass_tile: FloorTile= load("uid://bxxs348bao3ex")
	var swamp_tile: FloorTile= load("uid://cxqei5n8ibjfn")
	var asphalt_tile: FloorTile= load("uid://b316rjq10i810")
	var river_tile: FloorTile= load("uid://cjvucgx3b5qh7")

	var house_tile: BuildingTile= load("uid://ccsx6qxw27xhb")
	var factory_tile: BuildingTile= load("uid://c1mueqekg8h8x")

	var size:= 10

	for x in size:
		for y in size:
			var tile:= Vector2i(x, y) - Vector2i.ONE * size / 2
			if RngUtils.chance100(5):
				city.place_tile(swamp_tile, tile)
			else:
				city.place_tile(grass_tile, tile) 

	if RngUtils.chance100(100):
		var x= randi() % size
		for y in size:
			city.place_tile(river_tile, Vector2i(x, y) - Vector2i.ONE * size / 2)

	for x in size:
		for y in size:
			var tile:= Vector2i(x, y) - Vector2i.ONE * size / 2
			if RngUtils.chance100(5):
				city.place_tile(house_tile, tile)
			elif RngUtils.chance100(1):
				city.place_tile(factory_tile, tile)
