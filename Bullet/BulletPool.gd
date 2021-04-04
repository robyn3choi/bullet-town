class_name BulletPool
extends Node

const pool_size = 20
export var bullet_scene = preload("res://Bullet/Bullet.tscn")
var bullets = []

func _ready() -> void:
	for i in pool_size:
		var bullet = bullet_scene.instance()
		bullets.push_back(bullet)
		add_child(bullet)


func spawn() -> Bullet:
	if bullets.size() > 0:
		for i in pool_size:
			if !bullets[i].is_shooting:
				return bullets[i]
				
	print("out of bullets! returning first bullet")
	return bullets[0]
		
