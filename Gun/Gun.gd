extends Node2D

func _input(event):
	if event is InputEventMouseMotion:
		look_at(event.position)
		# keep rotation_degrees between 0 and 360
		rotation_degrees = fposmod(rotation_degrees, 360.0)
		print(rotation_degrees)
		if rotation_degrees > 90 && rotation_degrees < 270:
			$Sprite.flip_v = true
		else:
			$Sprite.flip_v = false
