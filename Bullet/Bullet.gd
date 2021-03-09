class_name Bullet
extends Node2D

const speed = 2
var is_shooting = false

func _ready():
	visible = false

func _physics_process(delta):
	if is_shooting:
		position += transform.x * speed

func shoot(target):
	visible = true
	is_shooting = true
	look_at(target)
	

func _on_VisibilityNotifier2D_screen_exited() -> void:
	is_shooting = false
	visible = false
