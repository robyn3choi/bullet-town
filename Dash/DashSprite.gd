extends Sprite

func _ready() -> void:
	material.set_shader_param("mix_weight", 1.0)
	material.set_shader_param("whiten", true)

func _process(delta) -> void:
	modulate.a = lerp(modulate.a, 0, 0.07)
	if modulate.a < 0.01:
		queue_free()
