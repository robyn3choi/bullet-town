extends Node

export var trail_length = 5
export(Vector2) var offset
onready var line = $Line2D
var is_enabled = true

func _physics_process(delta: float) -> void:
	var point = get_parent().global_position + offset
	line.add_point(point)
	while line.get_point_count() > trail_length:
		line.remove_point(0)
	
	if !is_enabled:
		trail_length = lerp(trail_length, 0, 0.25)
		if trail_length < 1:
			trail_length = 0

func disable():
#	is_enabled = false
#	line.points = []
	is_enabled = false
	
func enable():
	is_enabled = true
	trail_length = 100
