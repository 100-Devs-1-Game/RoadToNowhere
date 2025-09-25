class_name CardContainer
extends PanelContainer

@onready var card: Card = %Card


func init(data: CardData):
	card.init(data)
	
