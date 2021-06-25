class_name Bullet
extends Node2D

const speed = 120
const rotation_speed = 10
const knockback_force = 4

onready var sprite = $Sprite
onready var impact_anim: AnimatedSprite = $ImpactAnim
var is_moving = true
var velocity = Vector2(0, 0)

func _physics_process(delta):
	if is_moving:
		position += velocity * delta
		sprite.rotation += rotation_speed * delta
	
	
func shoot(aim_angle):
	velocity = Vector2(cos(aim_angle), sin(aim_angle)) * speed
	

func impact():
	is_moving = false
	$Trail.disable()
	sprite.visible = false
	impact_anim.visible = true
	impact_anim.rotation = sprite.rotation
	impact_anim.play()	


func _on_Bullet_body_entered(body: Node) -> void:
	impact()

func _on_Bullet_area_entered(area: Area2D) -> void:
	impact()

func _on_ImpactAnim_animation_finished() -> void:
	queue_free()
