extends KinematicBody2D

const speed = 100

var velocity = Vector2.ZERO
#onready var animation_player = $AnimationPlayer
#onready var animation_tree = $AnimationTree
#onready var animation_state = animation_tree.get("parameters/playback")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
#		animation_tree.set("parameters/Idle/blend_position", input_vector)
#		animation_tree.set("parameters/Run/blend_position", input_vector)
#		animation_state.travel("Run")
		velocity = input_vector * speed
	else:
#		animation_state.travel("Idle")
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
