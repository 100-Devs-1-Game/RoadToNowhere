extends Camera2D

@export var pan_speed: float= 500.0
@export var clamp_range: float= 300.0


func _process(delta: float) -> void:
	var pan: Vector2= Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	var pan_move: Vector2= pan.round() * pan_speed * delta
	var new_position: Vector2= position + pan_move
	if abs(new_position.x) < clamp_range:
		position.x= new_position.x
	if abs(new_position.y) < clamp_range:
		position.y= new_position.y
