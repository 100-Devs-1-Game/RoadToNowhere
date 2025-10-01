extends Node

var money: int
var campaign_data
var deck: Deck= Deck.new()
var max_deck_size: int= 10
var has_swap_joker: bool= false
var has_skip_joker: bool= false



func buy(cost: int):
	money-= cost
	AudioManager.play_sound("cash")


func update_level_score(score: int):
	if campaign_data:
		campaign_data.update_level_score(score)


func earn(amount: int):
	money+= amount
	AudioManager.play_sound("highscore")


func serialize()-> Dictionary:
	var dict:= {}
	dict["money"]= money
	dict["deck"]= deck.serialize()
	dict["max_size"]= max_deck_size
	dict["swap"]= has_swap_joker
	dict["skip"]= has_skip_joker
	return dict


func deserialize(dict: Dictionary):
	money= dict["money"]
	deck.deserialize(dict["deck"])
	max_deck_size= dict["max_size"]
	has_swap_joker= dict["swap"] 
	has_skip_joker= dict["skip"] 


func get_money_str()-> String:
	return str("$", money)


func is_deck_perfect_size()-> bool:
	return deck.get_size() == max_deck_size
