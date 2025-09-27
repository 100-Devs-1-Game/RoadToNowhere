extends Node

var money: int
var campaign_data



func buy(cost: int):
	money-= cost


func update_level_score(score: int):
	if campaign_data:
		campaign_data.update_level_score(score)
