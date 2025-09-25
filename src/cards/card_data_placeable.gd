class_name CardDataPlaceable
extends CardData

@export var tile: PlaceableTile



func get_display_name()-> String:
	return tile.name


func get_icon()-> Texture2D:
	return tile.card_icon
