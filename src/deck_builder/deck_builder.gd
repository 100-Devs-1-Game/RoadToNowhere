class_name DeckBuilder
extends PanelContainer

@export var card_container_scene: PackedScene

@onready var display_container: GridContainer = %GridContainer



func _ready() -> void:
	for i in 10:
		var tile: PlaceableTile
		if i < Global.card_pool.size():
			tile= Global.card_pool[i]
		var card_container: CardContainer= card_container_scene.instantiate()
		display_container.add_child(card_container)
		card_container.init(tile)
