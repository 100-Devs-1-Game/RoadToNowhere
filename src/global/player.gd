extends Node

var money: int
var current_level: int
var campaign: Campaign



func buy(cost: int):
	money-= cost


func update_level_score(score: int):
	if campaign:
		campaign.update_level_score(current_level, score)
