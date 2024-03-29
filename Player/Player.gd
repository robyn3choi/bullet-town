extends KinematicBody2D

var DirString = Globals.DirectionString
const speed = 6000
const dash_speed = 23000
const dash_duration = 0.16
const invincibility_duration = 1.2

onready var sprite = $BodySprite
onready var anim_player = $AnimationPlayer
onready var gun = $Gun
onready var health = $Health
onready var hurtbox = $Hurtbox
onready var blinker = $Blinker
onready var dash = $Dash

export var is_wielding = true
var is_using_joystick = false
var mouse_direction = Vector2(0, 1)
var last_move_direction = Vector2(0, 1)
var last_joystick_direction = Vector2(0, 1)

func _ready():
	randomize()  # TODO: move to more general class

	Globals.player = self
	anim_player.play("idle_down")
	$Hands.is_wielding = is_wielding
	
	if ! is_wielding:
		gun.queue_free()


func _input(event):
	if event is InputEventMouseMotion:
		is_using_joystick = false
		var angle_to_cursor = get_angle_to(get_global_mouse_position())
		mouse_direction.x = 0
		if angle_to_cursor >= -PI * 3 / 8 && angle_to_cursor < PI * 3 / 8:
			mouse_direction.x = 1
		elif angle_to_cursor > PI * 5 / 8 || angle_to_cursor < -PI * 5 / 8:
			mouse_direction.x = -1

		mouse_direction.y = -1 if angle_to_cursor > -PI && angle_to_cursor < 0 else 1

		if is_wielding:
			gun.aim_with_mouse(angle_to_cursor, get_global_mouse_position())


func _physics_process(delta):
	var move_direction = Vector2(
		int(Input.is_action_pressed('ui_right')) - int(Input.is_action_pressed('ui_left')),
		int(Input.is_action_pressed('ui_down')) - int(Input.is_action_pressed('ui_up'))
	)

	if (
		Input.is_action_just_pressed("dash")
		&& dash.can_dash
		&& ! dash.is_dashing()
		&& move_direction != Vector2.ZERO
	):
		dash.start_dash(sprite, dash_duration, move_direction)
		hurtbox.is_invincible = true
		last_move_direction = move_direction

	if dash.is_dashing():
		var velocity = last_move_direction.normalized() * dash_speed * delta
		move_and_slide(velocity)
		return

	if move_direction != Vector2.ZERO:
		last_move_direction = move_direction

	var velocity = move_direction.normalized() * speed * delta
	move_and_slide(velocity)

	var joystick_direction = Vector2(
		int(Input.is_action_pressed('aim_right')) - int(Input.is_action_pressed('aim_left')),
		int(Input.is_action_pressed('aim_down')) - int(Input.is_action_pressed('aim_up'))
	)

	if joystick_direction != Vector2.ZERO:
		last_joystick_direction = joystick_direction
		is_using_joystick = true

	play_anim(move_direction, get_facing_direction())

	if is_wielding && is_using_joystick && joystick_direction != Vector2.ZERO:
		gun.aim_with_joystick()


func get_facing_direction():
	var facing_direction = last_move_direction
	if is_wielding:
		facing_direction = last_joystick_direction if is_using_joystick else mouse_direction
	return facing_direction


func play_anim(move_direction, facing_direction):
	if move_direction == Vector2.ZERO:
		anim_player.play("idle_" + DirString[facing_direction])
	else:
		if should_play_anim_backwards(move_direction, facing_direction):
			anim_player.play_backwards("run_" + DirString[facing_direction])
		else:
			anim_player.play("run_" + DirString[facing_direction])


func should_play_anim_backwards(move_direction, facing_direction):
	# one y is 1 and the other is -1, and x's don't match
	# one x is 1 and the other is -1
	# moving straight up or down and aiming in opposite direction
	return (
		(abs(move_direction.y - facing_direction.y) == 2 && move_direction.x != facing_direction.x)
		|| (abs(move_direction.x - facing_direction.x) == 2)
		|| (move_direction.x == 0 && move_direction.y != facing_direction.y)
	)


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if ! hurtbox.is_invincible:
		health.current_health -= 0.5
		hurtbox.start_invincibility_blink(invincibility_duration)
		blinker.start_blinking([$ShadowSprite, sprite, gun], invincibility_duration)
		Globals.camera.start_shake()


func _on_Health_no_health() -> void:
	print("dead")


func _on_Dash_dash_ended() -> void:
	 hurtbox.is_invincible = false


func _on_Gun_switched_hands(is_on_right) -> void:
	$Hands.set_gun_hand(is_on_right)
