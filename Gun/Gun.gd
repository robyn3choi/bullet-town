extends Node2D

export var left_pos: Vector2
export var right_pos: Vector2

var is_on_right = true
var switch_buffer = 40
var switch_disable_distance = 500
onready var muzzle_offset_y = $Sprite/Muzzle.global_position.y - global_position.y

func _ready():
	position = right_pos

func _input(event):
	if event is InputEventMouseMotion:			
		# keep rotation_degrees between 0 and 360
		rotation_degrees = fposmod(rotation_degrees, 360.0)
		var is_switch_disabled = is_switch_disabled()	
			
		if should_be_on_right() && !is_on_right && !is_switch_disabled:
			switch_to_right()
		elif !should_be_on_right() && is_on_right && !is_switch_disabled:
			switch_to_left()

		look_at_target(event.position)
		
		
func should_be_on_right():
	if is_on_right:
		return rotation_degrees <= 90 + switch_buffer || rotation_degrees > 270 - switch_buffer
	else:
		return rotation_degrees <= 90 - switch_buffer || rotation_degrees > 270 + switch_buffer

func is_switch_disabled():
	var distance_to_target = global_position.distance_squared_to(get_global_mouse_position())
	return distance_to_target < switch_disable_distance
	
func switch_to_right():
	$Sprite.scale = Vector2(1, 1)
	$Sprite.position.y -= $Sprite.texture.get_height()
	position = right_pos
	is_on_right = true
	
func switch_to_left():
	$Sprite.scale = Vector2(1, -1)
	$Sprite.position.y += $Sprite.texture.get_height()
	position = left_pos
	is_on_right = false
	
func look_at_target(cursor_pos):
	var look_at_pos = cursor_pos;
	var multipler = -1 if is_on_right else 1
	look_at_pos += transform.y * muzzle_offset_y * multipler
	look_at(look_at_pos)
