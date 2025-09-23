class_name PlaceableTile
extends BaseTile

# will probably be the same as in the TileSet
# but may be easier to store redundantly than to extract
@export var card_icon: Texture2D
@export var can_rotate: bool= true



func can_place_at(tile: Vector2i)-> bool:
	return true


func get_card_icon()-> Texture2D:
	return card_icon
