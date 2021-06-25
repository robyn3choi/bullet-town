extends Node2D

signal switched_hands

export var left_pos: Vector2
export var right_pos: Vector2

onready var gun_sprite = $Pivot/Sprite
onready var muzzle = $Pivot/Sprite/Muzzle
onready var muzzle_offset_y = muzzle.global_position.y - global_position.y
#onready var bullet_pool = $BulletPool
onready var shoot_timer: Timer = $ShootTimer
onready var blast_anim: AnimatedSprite = $BlastAnimatedSprite

onready var twig_particles = $TwigParticles
onready var smoke_particles = $SmokeParticles

onready var blast_pos: Node2D = $BlastPosition
onready var anim_player: AnimationPlayer = $AnimationPlayer
var bullet_scene = preload("res://Bullet/Bullet.tscn")
var is_on_right = true
var switch_buffer = 0
var switch_disable_distance = 500
var is_shooting = false
var time_since_last_shoot = 0.0
var switch_y_offset = 8 # gun_sprite.texture.get_height()

func _ready():
	position = right_pos
	remove_child(blast_anim)
	get_tree().root.call_deferred("add_child", blast_anim)
	get_tree().root.call_deferred("add_child", blast_anim)
	
	remove_child(twig_particles)
	remove_child(smoke_particles)
	get_tree().root.call_deferred("add_child", twig_particles)
	get_tree().root.call_deferred("add_child", smoke_particles)


func aim_with_mouse(angle_to_cursor, cursor_pos):
	switch_sides_if_needed(angle_to_cursor)
	look_at_target(cursor_pos)	
	

func aim_with_joystick():
	var joystick_input = Vector2(
		Input.get_action_strength('aim_right') - Input.get_action_strength('aim_left'),
		Input.get_action_strength('aim_down') - Input.get_action_strength('aim_up'))

	var aim_angle = joystick_input.angle()
	switch_sides_if_needed(aim_angle)
	rotation = aim_angle
	
	
func switch_sides_if_needed(aim_angle):
	var is_aiming_right = true if aim_angle >= -PI/2 && aim_angle < PI/2 else false
	if is_aiming_right && !is_on_right:
		switch_to_right()
	elif !is_aiming_right && is_on_right:
		switch_to_left()
	
	
func switch_to_right():
	gun_sprite.scale = Vector2(1, 1)
	gun_sprite.position.y -= switch_y_offset
	position = right_pos
	is_on_right = true
	emit_signal('switched_hands', true)
	
func switch_to_left():
	gun_sprite.scale = Vector2(1, -1)
	gun_sprite.position.y += switch_y_offset
	position = left_pos
	is_on_right = false
	emit_signal('switched_hands', false)
	
func look_at_target(cursor_pos):
	var look_at_pos = cursor_pos;
	var multipler = -1 if is_on_right else 1
	look_at_pos += transform.y * muzzle_offset_y * multipler
	look_at(look_at_pos)


func _process(delta):
	if Input.is_action_pressed("shoot") && shoot_timer.is_stopped():
		is_shooting = true
		shoot()
		shoot_timer.start()
	else:
		is_shooting = false 


func shoot():
	var bullet = bullet_scene.instance()
	get_tree().root.add_child(bullet)
	bullet.position = muzzle.global_position
	bullet.shoot(rotation)
	anim_player.play("shoot_right") if is_on_right else anim_player.play("shoot_left")

	blast_anim.global_position = blast_pos.global_position
	blast_anim.global_rotation = blast_pos.global_rotation
	blast_anim.visible = true
	blast_anim.frame = 0
	blast_anim.play()
#	twig_particles.global_position = blast_pos.global_position
#	smoke_particles.global_position = blast_pos.global_position
#	twig_particles.global_rotation = blast_pos.global_rotation
#	smoke_particles.global_rotation = blast_pos.global_rotation
#	twig_particles.restart()
#	smoke_particles.restart()
#	twig_particles.emitting = true
#	smoke_particles.emitting = true
	


func _on_ShootTimer_timeout() -> void:
	shoot() if is_shooting else shoot_timer.stop()



func _on_BlastAnimatedSprite_animation_finished() -> void:
	blast_anim.stop()
	blast_anim.visible = false

