class_name CardContainer
extends PanelContainer

@onready var card: Card = %Card


func init(tile: PlaceableTile):
	card.init(tile)
	
