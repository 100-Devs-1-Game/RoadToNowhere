extends Node

@onready var canvas_layer: CanvasLayer= $CanvasLayer

class PositionLabel:
	var pos: Vector2
	var label: Label
	var floating: bool
	var floating_y_pos: float

	func _init(_pos: Vector2, _label: Label, _floating: bool):
		pos= _pos
		label= _label
		floating= _floating

var position_labels: Array[PositionLabel]


func _process(delta):
	for pos_label in position_labels:
		if pos_label.floating:
			pos_label.label.position-= Vector2(0, delta * 100)


func add(pos: Vector2, text: String, duration: float= 1, color: Color= Color.WHITE, font_size: int= 20, fade: bool= true, floating: bool= false):
	var label:= Label.new()
	label.text= text
	label.position= pos
	label.modulate= color
	label.add_theme_font_size_override("font_size", font_size)
	canvas_layer.add_child(label)
	label.position.x-= label.get_rect().size.x / 2

	var pos_label: PositionLabel
	if floating:
		pos_label= PositionLabel.new(pos, label, floating)
		position_labels.append(pos_label)
	
	await get_tree().create_timer(duration).timeout

	if fade:
		var tween: Tween= label.create_tween()
		tween.tween_property(label, "modulate", Color.TRANSPARENT, 0.25)
		await tween.finished
	
	if pos_label:
		position_labels.erase(pos_label)
	
	label.queue_free()


#func attack_blocked(entity: MapEntity):
	#if not is_instance_valid(entity) or not entity: return
	#text_overlay(entity.get_global_transform_with_canvas().origin - Vector2(0, 50), "Blocked", 1, Color.ORANGE, 22, true, true) 


#func add_tile_label(tile: Vector2i, s):
	#var label:= Label.new()
	#if s is float:
		#label.text= "%1.3f" % s
	#else:
		#label.text= str(s)
	#
	#label.position= Global.map.map_to_local(tile) - Vector2(10, 10)
	#Global.map.add_child(label)
	#
