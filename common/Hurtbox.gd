extends Area2D

export (ShaderMaterial) var whiten_material
onready var collision_shape = $CollisionShape2D
const whiten_duration = 0.15
var is_invincible = false setget set_is_invincible

func set_is_invincible(value):
	is_invincible = value
	if is_invincible:
		collision_shape.set_deferred("disabled", true)
	else:
		collision_shape.set_deferred("disabled", false)


func start_invincibility_blink(invincibility_duration):
	is_invincible = true
	yield(get_tree().create_timer(invincibility_duration), "timeout")
	is_invincible = false


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	whiten_material.set_shader_param("whiten", true)
	yield(get_tree().create_timer(whiten_duration), "timeout")
	whiten_material.set_shader_param("whiten", false)
