class_name LevelStateMachine
extends FiniteStateMachine

@onready var draw_card: DrawCardState = $"Draw Card"
@onready var place_tile: PlaceTileState = $"Place Tile"
@onready var run_action: RunActionState = $"Run action"
@onready var scoring_phase: ScoringPhaseState = $"Scoring Phase"
@onready var help_mode: Node = $"Help Mode"



func _ready() -> void:
	super()
	draw_card.drawn_card.connect(on_card_drawn)
	place_tile.finished.connect(on_card_placed)
	run_action.finished.connect(on_card_placed)


func on_card_drawn(card_data: CardData):
	if card_data is CardDataPlaceable:
		place_tile.tile_to_place= (card_data as CardDataPlaceable).tile
		change_state(place_tile)
	else:
		run_action.action= (card_data as CardDataAction).action
		change_state(run_action)


func on_card_placed():
	Global.level.pop_deck()
	if Global.level.is_deck_empty():
		change_state(scoring_phase)
	else:
		change_state(draw_card)


func toggle_help_mode(toggle: bool):
	if current_state == scoring_phase:
		return

	if toggle:
		change_state(help_mode)
	else:
		var return_to: StateMachineState= previous_state
		change_state(return_to)
		
