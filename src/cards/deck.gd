class_name Deck

class DeckCard:
	var tile: PlaceableTile
	
	func _init(_tile: PlaceableTile):
		tile= _tile


var cards: Array[DeckCard]



func add_card(tile: PlaceableTile):
	cards.append(DeckCard.new(tile))


func clear():
	cards.clear()


func shuffle():
	cards.shuffle()


func pop()-> PlaceableTile:
	var card: DeckCard= cards.pop_back()
	return card.tile


func get_size()-> int:
	return cards.size()


func is_empty()-> bool:
	return cards.is_empty()
