extends Node2D

export var left_pos: Vector2
export var right_pos: Vector2

onready var gun_sprite = $Sprite
onready var muzzle_offset_y = $Sprite/Muzzle.global_position.y - global_position.y
#onready var bullet_pool = $BulletPool
onready var shoot_timer: Timer = $ShootTimer
var bullet_scene = preload("res://Bullet/Bullet.tscn")
var is_on_right = true
var switch_buffer = 0
var switch_disable_distance = 500
var is_shooting = false
var time_since_last_shoot = 0.0

func _ready():
	position = right_pos


func aim_with_mouse(angle_to_cursor, cursor_pos):
	switch_sides_if_needed(angle_to_cursor)
	look_at_target(cursor_pos)	
	

func aim_with_joystick():
	print("joy")
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
	gun_sprite.position.y -= gun_sprite.texture.get_height()
	position = right_pos
	is_on_right = true
	
func switch_to_left():
	gun_sprite.scale = Vector2(1, -1)
	gun_sprite.position.y += gun_sprite.texture.get_height()
	position = left_pos
	is_on_right = false
	
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
	bullet.position = ($Sprite/Muzzle.global_position)
	bullet.shoot(rotation)


func _on_ShootTimer_timeout() -> void:
	shoot() if is_shooting else shoot_timer.stop()

