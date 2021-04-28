class_name Bullet
extends Node2D

const speed = 120


func _physics_process(delta):
	position += transform.x * speed * delta
	
	
func shoot(aim_angle):
	rotation = aim_angle


func _on_Bullet_body_entered(body: Node) -> void:
	if body.collision_layer == 1:
		queue_free()
