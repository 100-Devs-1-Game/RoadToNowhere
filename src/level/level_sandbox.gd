extends Node

@export var generate_random_deck: bool= false
@export var card_pool: Array[PlaceableTile]
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
		deck.add_card(card_pool.pick_random())
	level.deck= deck
	level.build_deck()

func generate_city():
	var city: City= Global.city

	var dirt_tile: FloorTile= load("uid://b316rjq10i810")
	var house_tile: BuildingTile= load("uid://ccsx6qxw27xhb")
	var factory_tile: BuildingTile= load("uid://c1mueqekg8h8x")

	var size:= 9

	for x in size:
		for y in size:
			var tile:= Vector2i(x, y) - Vector2i.ONE * size / 2
			city.place_tile(dirt_tile, tile) 
			if randf() < 0.1:
				city.place_tile(house_tile, tile)
			elif randf() < 0.05:
				city.place_tile(factory_tile, tile)
