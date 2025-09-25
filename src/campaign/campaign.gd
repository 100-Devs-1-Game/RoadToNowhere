class_name Campaign

var level_data: Array[LevelData]
var level_scores: Array[int]



func update_level_score(level_index: int, score: int):
	var current_score: int= level_scores[level_index]
	if score > current_score:
		var delta: int= score - current_score
		level_scores[level_index]= score
		Player.earn(delta)
