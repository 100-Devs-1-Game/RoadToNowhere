class_name Deck

class DeckCard:
	var data: CardData
	
	func _init(_data: CardData):
		data= _data


var cards: Array[DeckCard]



func add_card(data: CardData):
	cards.append(DeckCard.new(data))


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
