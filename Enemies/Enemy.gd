extends KinematicBody2D

#onready var bullet_pool = $BulletPool
var bullet_scene = preload("res://Bullet/Bullet.tscn")

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var burst_timer: Timer = $BurstTimer
onready var bullet_timer: Timer = $BulletTimer

var move_speed = 20
var bullet_speed = 1000
var burst_bullets = 3
var burst_delay = 2
var bullet_delay = 0.5
var burst_bullets_left = burst_bullets
var is_moving = false

func _ready():
	is_moving = true
	burst_timer.wait_time = burst_delay
	burst_timer.start()
	bullet_timer.wait_time = bullet_delay

func _physics_process(delta: float) -> void:
	if Globals.player && is_moving:
		var raw_direction = (Globals.player.position - position).normalized()
		var direction = Vector2(int(round(raw_direction.x)), int(round(raw_direction.y)))
		var velocity = direction * move_speed * delta
		move_and_collide(velocity)
		
		if raw_direction.y >= 0:
			var curr_anim_pos = anim_player.current_animation_position
			anim_player.play("run_down")
			anim_player.seek(curr_anim_pos)
		else:
			var curr_anim_pos = anim_player.current_animation_position
			anim_player.play("run_up")
			anim_player.seek(curr_anim_pos)

func shoot():
	var bullet = bullet_scene.instance()
	bullet.set_position(position)
	bullet.shoot(get_angle_to(Globals.player.position))
	burst_bullets_left -= 1
	if burst_bullets_left > 0:
		bullet_timer.start()
	else:
		burst_timer.start()
		
		
func _on_BulletTimer_timeout() -> void:
	shoot()


func _on_BurstTimer_timeout() -> void:
	burst_bullets_left = burst_bullets
	shoot()

func stop_moving():
	is_moving = false
	
func start_moving():
	is_moving = true
