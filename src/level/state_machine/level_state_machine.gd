class_name LevelStateMachine
extends FiniteStateMachine

@onready var draw_card: DrawCardState = $"Draw Card"
@onready var place_tile: PlaceTileState = $"Place Tile"
@onready var scoring_phase: ScoringPhaseState = $"Scoring Phase"



func _ready() -> void:
	super()
	draw_card.drawn_card.connect(on_card_drawn)
	place_tile.finished.connect(on_placed_tile)


func on_card_drawn(tile_to_place: PlaceableTile):
	place_tile.tile_to_place= tile_to_place
	change_state(place_tile)


func on_placed_tile():
	Global.level.pop_deck()
	if Global.level.is_deck_empty():
		change_state(scoring_phase)
	else:
		change_state(draw_card)
