extends Node

signal health_changed
signal no_health

export var max_health = 1
onready var current_health = max_health setget set_health

func set_health(value):
	current_health = value
	emit_signal('health_changed', value)
	
	if current_health <= 0:
		emit_signal('no_health')
