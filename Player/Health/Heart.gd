extends Control

export var textures = { 1: null, 0.75: null, 0.5: null, 0.25: null }
onready var fill = $Fill

func set_value(value):
	if value == 0:
		fill.texture = null
	else:
		fill.texture = textures[value]
