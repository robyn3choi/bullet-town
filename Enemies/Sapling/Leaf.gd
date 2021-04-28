extends Area2D

const speed = 100
const rotation_speed = 15

export var texture: Texture

var initial_position
var is_attacking = false
var attack_direction


func _ready():
	initial_position = position
	visible = false
	$Sprite.texture = texture


func _process(delta):
	if is_attacking:
		global_position += attack_direction * speed * delta
		rotation += rotation_speed * delta


func spawn():
	visible = true


func attack():
	is_attacking = true
	attack_direction = (Globals.player.position - global_position).normalized()


func recycle():
	is_attacking = false
	visible = false
	position = initial_position
	rotation = 0


func _on_Leaf_body_entered(body: Node) -> void:
	if body.collision_layer == 1:  # wall
		recycle()
