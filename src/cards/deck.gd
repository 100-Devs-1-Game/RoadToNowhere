class_name Deck

class DeckCard:
	var data: CardData
	
	func _init(_data: CardData):
		data= _data


var cards: Array[DeckCard]



func add_card(data: CardData):
	cards.append(DeckCard.new(data))


func copy()-> Deck:
	var new_deck:= Deck.new()
	for card in cards:
		new_deck.add_card(card.data)
	return new_deck


func clear():
	cards.clear()


func shuffle():
	cards.shuffle()


func pop()-> CardData:
	var card: DeckCard= cards.pop_back()
	return card.data


func half():
	var half_size: int= int(cards.size() / 2)
	while cards.size() > half_size:
		cards.pop_back()


func remove_card(data: CardData):
	for card in cards:
		if card.data == data:
			cards.erase(card)
			return
	assert(false)


func get_size()-> int:
	return cards.size()


func get_card_count(data: CardData)-> int:
	var result: int= 0
	for card in cards:
		if card.data == data:
			result+= 1
	return result


func is_empty()-> bool:
	return cards.is_empty()
