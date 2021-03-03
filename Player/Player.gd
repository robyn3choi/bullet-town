extends KinematicBody2D

const speed = 50

onready var anim_player = $AnimationPlayer
var velocity = Vector2.ZERO
var last_input_vector = Vector2(0, 1)

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = int(Input.is_action_pressed('ui_right')) - int(Input.is_action_pressed('ui_left'))
	input_vector.y = int(Input.is_action_pressed('ui_down')) - int(Input.is_action_pressed('ui_up'))
	
	print(input_vector)

	if input_vector != Vector2.ZERO:
		last_input_vector = input_vector
		play_anim('run') 
		velocity = input_vector.normalized() * speed
		
	else:
		play_anim('idle')
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
	
func play_anim(action: String): 
	match last_input_vector:
		Vector2(-1, 0), Vector2(-1, 1):
			anim_player.play(action + '_down-left')
		Vector2(0, 1):
			anim_player.play(action + '_down')
		Vector2(1, 0), Vector2(1, 1):
			anim_player.play(action + '_down-right')
		Vector2(-1, -1):
			anim_player.play(action + '_up-left')
		Vector2(0, -1):
			anim_player.play(action + '_up')
		Vector2(1, -1):
			anim_player.play(action + '_up-right')
