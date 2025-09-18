class_name DrawCardState
extends StateMachineState

signal drawn_card(tile_to_place: PlaceableTile)


func on_card_drawn():
	if is_current_state():
		drawn_card.emit(Global.level.draw_card())
		return
