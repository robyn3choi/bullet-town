extends KinematicBody2D

var DirVector = Globals.DirectionVector
var DirString = Globals.DirectionString

const speed = 50

onready var anim_player = $AnimationPlayer
onready var gun = $Gun

var is_using_joystick = false
var is_wielding = true 
var mouse_direction = Vector2(0, 1)
var last_move_direction = Vector2(0, 1)

func _ready():
	anim_player.play("idle_down") 

func _input(event):
	if event is InputEventMouseMotion:
		is_using_joystick = false
		var angle_to_cursor = get_angle_to(event.position)
		
		mouse_direction.x = 0
		if angle_to_cursor >= -PI*3/8 && angle_to_cursor < PI*3/8:
			mouse_direction.x = 1
		elif angle_to_cursor > PI*5/8 || angle_to_cursor < -PI*5/8:
			mouse_direction.x = -1

		mouse_direction.y = -1 if angle_to_cursor > -PI && angle_to_cursor < 0 else 1
		
		if is_wielding: gun.aim_with_mouse(angle_to_cursor, event.position)

			
func _physics_process(_delta):
	var move_direction = Vector2(
		int(Input.is_action_pressed('ui_right')) - int(Input.is_action_pressed('ui_left')),  
		int(Input.is_action_pressed('ui_down')) - int(Input.is_action_pressed('ui_up')))
	
	last_move_direction = move_direction
	
	var joystick_direction = Vector2(
		int(Input.is_action_pressed('aim_right')) - int(Input.is_action_pressed('aim_left')), 
		int(Input.is_action_pressed('aim_down')) - int(Input.is_action_pressed('aim_up')))
	
	is_using_joystick = joystick_direction != Vector2.ZERO
	
	play_anim(move_direction, get_facing_direction(joystick_direction))
	if is_wielding && is_using_joystick: gun.aim_with_joystick()
	var velocity = move_direction.normalized() * speed
	move_and_slide(velocity)
	

func get_facing_direction(joystick_direction):
	var facing_direction = last_move_direction
	if is_wielding:
		facing_direction = joystick_direction if is_using_joystick else mouse_direction
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
	return ((abs(move_direction.y - facing_direction.y) == 2 && move_direction.x != facing_direction.x)
			|| (abs(move_direction.x - facing_direction.x) == 2)
			|| (move_direction.x == 0 && move_direction.y != facing_direction.y))
