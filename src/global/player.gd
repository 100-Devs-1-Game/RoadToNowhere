extends Node

var money: int
var campaign_data
var deck: Deck= Deck.new()
var max_deck_size: int= 10



func buy(cost: int):
	money-= cost


func update_level_score(score: int):
	if campaign_data:
		campaign_data.update_level_score(score)


func get_money_str()-> String:
	return str("$", money)
