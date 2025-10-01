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


func swap():
	dump()
	cards.push_back(cards[-2])
	cards.remove_at(cards.size() - 3)
	dump()


func remove_card(data: CardData):
	for card in cards:
		if card.data == data:
			cards.erase(card)
			return
	assert(false)


func serialize()-> Dictionary:
	var dict:= {}
	var arr_id:= []
	for card in cards:
		arr_id.append(GameData.card_pool.find(card.data))
	dict["cards"]= arr_id
	return dict


func deserialize(dict: Dictionary):
	clear()
	for card_id: int in dict["cards"]:
		add_card(GameData.card_pool[card_id])


func dump():
	print("--Dump Deck--")
	for i in range(get_size() - 1, -1, -1):
		print(cards[i].data.get_display_name())


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
