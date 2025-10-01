class_name DynamicObjectTile
extends BaseTile

enum Behavior { STATIC, MOVING }

@export var can_build_on: bool= false
@export var behavior: Behavior
@export var build_on_sound: String



func tick(tile_pos: Vector2i):
	var city: City= Global.city
	
	match behavior:
		Behavior.MOVING:
			var dir:= get_random_direction()
			print(dir)
			var target_pos: Vector2i= tile_pos + dir
			if not city.is_in_bounds(target_pos):
				return
			if target_pos in city.get_dynamic_object_tiles():
				return
			city.move_dynamic_object(tile_pos, target_pos)


static func get_random_direction()-> Vector2i:
	var rnd_pos:= Vector2i(randi_range(-1, 1), randi_range(-1, 1))
	if rnd_pos == Vector2i.ZERO:
		return get_random_direction()
	return rnd_pos
