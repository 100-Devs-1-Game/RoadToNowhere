extends Camera2D

@export var pan_speed: float= 300.0



func _process(delta: float) -> void:
	var pan: Vector2= Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	position+= pan * pan_speed * delta
