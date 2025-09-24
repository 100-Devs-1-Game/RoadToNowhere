class_name Utils



static func number_with_sign(num: int)-> String:
	if num > 0:
		return str("+", num)
	return str(num)


static func get_neighbor_tiles(tile: Vector2i, include_diagonal: bool= true, include_center: bool= false)-> Array[Vector2i]: 
	var result: Array[Vector2i]
	for x in range(-1, 2):
		for y in range(-1, 2):
			if x != 0 and y != 0 and not include_diagonal:
				continue
			var pos:= tile + Vector2i(x, y)
			if pos == tile and not include_center:
				continue
			result.append(pos)
	return result
