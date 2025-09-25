class_name CardDataPlaceable
extends CardData

@export var tile: PlaceableTile



func get_icon()-> Texture2D:
	return tile.card_icon
