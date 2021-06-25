extends KinematicBody2D

const move_speed = 30
const leaf_speed = 1000
const attack_distance = 80

onready var leaves_parent = $Leaves
onready var anim_tree = $AnimationTree
onready var state_machine = anim_tree["parameters/playback"]
onready var leaf_shoot_timer: Timer = $LeafShootTimer
onready var soft_collision = $SoftCollision
onready var health = $Health

var leaves = []
var leaf_index = 0
var leaves_recycled = 0
var is_moving = false
var is_attacking = false
var is_dead = false
var last_hit_velocity = Vector2(0, 0)
var knockback: Vector2 = Vector2(0, 0)

func _ready():
	is_moving = true
	for l in leaves_parent.get_children():
		leaves.push_back(l)


func _physics_process(delta: float) -> void:
	if Globals.player && !is_dead:
		if ! is_attacking && position.distance_to(Globals.player.position) < attack_distance:
			is_attacking = true
			is_moving = false

			# attack and recover anim direction should matching the current facing direction
			var run_blend_pos = anim_tree["parameters/run/blend_position"]
			anim_tree["parameters/attack/blend_position"] = run_blend_pos
			anim_tree["parameters/recover/blend_position"] = run_blend_pos
			state_machine.travel("attack")

			leaves_parent.scale.x = 1
			if run_blend_pos < 0:
				leaves_parent.scale.x = -1

		if knockback != Vector2.ZERO:
			move_and_collide(knockback)
			knockback = knockback.move_toward(Vector2.ZERO, 1)
			print(knockback)
		elif is_moving:
			move(delta)

func move(delta):
	state_machine.travel("run")
	var raw_direction = (Globals.player.position - position).normalized()

	anim_tree["parameters/run/blend_position"] = raw_direction.y

	var direction = Vector2(int(round(raw_direction.x)), int(round(raw_direction.y)))
	var velocity = (direction + soft_collision.get_push_vector()) * move_speed * delta
	move_and_collide(velocity)


func stop_moving():
	is_moving = false


func start_moving():
	is_attacking = false
	is_moving = true


func start_attack():
	for l in leaves:
		if l.is_attacking:
			l.recycle()
		l.spawn()
	leaves.shuffle()
	leaf_shoot_timer.start()
	$AttackDurationTimer.start()


func shoot_leaf():
	leaves[leaf_index].attack()
	leaf_index += 1
	if leaf_index < leaves_parent.get_child_count():
		leaf_shoot_timer.start()


func finish_attack():
	leaf_index = 0
	leaves_recycled = 0
	if !is_dead: state_machine.travel("recover")
	

func finish_death():
	queue_free()


func _on_LeafShootTimer_timeout() -> void:
	shoot_leaf()


func _on_AttackDurationTimer_timeout() -> void:
	finish_attack()


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if "knockback_force" in area:
		knockback = area.knockback_force * area.velocity.normalized()
	last_hit_velocity = area.velocity
	$Health.current_health -= 1


func _on_Health_no_health() -> void:
	is_dead = true
	Globals.camera.start_shake(0.15, 1.5)
	$Hurtbox.is_invincible = true
	$CollisionShape2D.set_deferred("disabled", true)
	
	if is_attacking:
		$Sprite.visible = false
	else:
		$Sprite.scale.x = leaves_parent.scale.x
	
	state_machine.travel("die")
	
	$ShadowSprite.visible = false
	$Leaves.visible = false
	
	var particles_direction = Vector3(last_hit_velocity.x, last_hit_velocity.y, 0)
	$Shards1.process_material.direction = particles_direction
	$Shards2.process_material.direction = particles_direction
	$Shards1.emitting = true
	$Shards2.emitting = true
