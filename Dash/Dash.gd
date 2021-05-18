extends Node2D

signal dash_ended

const dash_sprite_instance_delay = 0.03
const dash_delay = 0.4

onready var duration_timer = $DurationTimer
onready var instance_timer = $InstanceTimer
onready var dust_particles = $DustParticles
onready var dust_burst_particles = $DustBurstParticles

var dash_sprite_scene = preload("res://Dash/DashSprite.tscn")
var original_sprite
var can_dash = true


func _ready():
	instance_timer.wait_time = dash_sprite_instance_delay


func is_dashing():
	return ! duration_timer.is_stopped()


func start_dash(sprite, duration, direction: Vector2):
	duration_timer.wait_time = duration
	original_sprite = sprite
	sprite.material.set_shader_param("mix_weight", 0.7)
	sprite.material.set_shader_param("whiten", true)
	instance_dash_sprite()

	instance_timer.start()
	duration_timer.start()
	
	dust_particles.restart()
	dust_particles.emitting = true

	dust_burst_particles.rotation = (direction * -1).angle()
	dust_burst_particles.restart()
	dust_burst_particles.emitting = true


func end_dash():
	instance_timer.stop()
	original_sprite.material.set_shader_param("whiten", false)
	emit_signal('dash_ended')
	
	can_dash = false
	yield(get_tree().create_timer(dash_delay), 'timeout')
	can_dash = true


func instance_dash_sprite():
	var dash_sprite: Sprite = dash_sprite_scene.instance()
	get_parent().get_parent().add_child(dash_sprite)
	# var current_scene = root.get_child(root.get_child_count()-1)
	# current_scene.add_child(bullet)

	dash_sprite.global_position = global_position
	dash_sprite.texture = original_sprite.texture
	dash_sprite.vframes = original_sprite.vframes
	dash_sprite.hframes = original_sprite.hframes
	dash_sprite.frame = original_sprite.frame
	dash_sprite.flip_h = original_sprite.flip_h


func _on_DurationTimer_timeout() -> void:
	end_dash()


func _on_InstanceTimer_timeout() -> void:
	instance_dash_sprite()
