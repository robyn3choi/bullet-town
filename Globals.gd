extends Node

#const DirectionVector = { 
#	"left": Vector2(-1, 0), 
#	"down-left": Vector2(-1, 1),
#	"down": Vector2(0, 1),
#	"down-right": Vector2(1, 1),
#	"right": Vector2(1, 0),
#	"up-left": Vector2(-1, -1),
#	"up": Vector2(0, -1),
#	"up-right": Vector2(1, -1)
#}

const DirectionString = {
	Vector2(-1, 0): "down-left",
	Vector2(-1, 1): "down-left",
	Vector2(0, 1): "down",
	Vector2(1, 1): "down-right",
	Vector2(1, 0): "down-right",
	Vector2(-1, -1): "up-left",
	Vector2(0, -1): "up",
	Vector2(1, -1): "up-right"
}
