class_name Bullet
extends Node2D

const speed = 120
var is_shooting = false

func _ready():
	visible = false

func _physics_process(delta):
	if is_shooting:
		position += transform.x * speed * delta
	
func shoot(aim_angle):
	visible = true
	is_shooting = true
	rotation = aim_angle

func _on_Bullet_body_entered(body: Node) -> void:
	if body.collision_layer == 1:
		print("coll")
#		is_shooting = false
#		visible = false
		queue_free()
