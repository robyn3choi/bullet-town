extends Node2D

onready var gun_hand = $GunHandSprite
onready var initial_gun_hand_x = gun_hand.position.x
onready var mask = $HandsMask
var is_wielding = false setget set_is_wielding


func set_is_wielding(value):
	is_wielding = value
	gun_hand.visible = is_wielding
	mask.visible = true

func set_gun_hand(is_on_right):
	if is_on_right:
		gun_hand.position = Vector2(initial_gun_hand_x, gun_hand.position.y)
		mask.scale.x = 1
	else:
		gun_hand.position = Vector2(initial_gun_hand_x * -1, gun_hand.position.y)
		mask.scale.x = -1
