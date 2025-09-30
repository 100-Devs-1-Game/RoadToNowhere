class_name CampaignData
extends Resource

@export var level_data: Array[LevelData]

var level_scores: Array[int]



func update_level_score(score: int):
	var level_index: int= level_data.find(SceneLoader.level_data)
	if level_scores.is_empty():
		level_scores.resize(level_data.size())

	var current_score: int= level_scores[level_index]
	if score > current_score:
		var delta: int= score - current_score
		level_scores[level_index]= score
		Player.earn(delta)


func serialize()-> Dictionary:
	var dict:= {}
	var arr:= []
	for level in level_data:
		arr.append(level.unlocked)
	dict["unlocked"]= arr
	dict["scores"]= level_scores.duplicate()
	return dict


func deserialize(dict: Dictionary):
	for i in level_data.size():
		level_data[i].unlocked= dict["unlocked"][i]
	level_scores.assign(dict["scores"])
