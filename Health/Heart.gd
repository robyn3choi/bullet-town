extends Control

export var textures = { 1: null, 0.75: null, 0.5: null, 0.25: null }
onready var fill = $Fill
onready var shards_big = $ShardsBig
onready var shards_small = $ShardsSmall

func set_value(value):
	if value == 0:
		if fill.texture != null:
			fill.texture = null
			shards_big.emitting = true
			shards_small.emitting = true
	else:
		fill.texture = textures[value]
