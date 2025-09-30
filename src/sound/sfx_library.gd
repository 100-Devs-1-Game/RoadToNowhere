class_name SFXLibrary
extends Resource

@export var items: Array[SFXLibraryItem]

var dict: Dictionary



func build():
	for item in items:
		assert(not dict.has(item.name))
		dict[item.name]= item
