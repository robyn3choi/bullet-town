extends Camera2D

const single_shake_duration = 0.03

onready var shake_tween: Tween = $ShakeTween
onready var duration_timer: Timer = $DurationTimer
var amplitude = 0
var is_shaking = false

func _ready() -> void:
	Globals.camera = self


func start_shake(duration = 0.2, amp = 2):
	if amp > amplitude:
		is_shaking = true
		amplitude = amp
		duration_timer.wait_time = duration
		duration_timer.start()
		shake()


func shake():
	var random_point = Vector2(rand_range(-amplitude, amplitude), rand_range(-amplitude, amplitude))

	shake_tween.interpolate_property(
		self,
		"offset",
		offset,
		random_point,
		single_shake_duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	shake_tween.start()


func end_shake():
	is_shaking = false
	amplitude = 0

	shake_tween.interpolate_property(
		self,
		"offset",
		offset,
		Vector2.ZERO,
		single_shake_duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	shake_tween.start()


func _on_ShakeTween_tween_completed(object: Object, key: NodePath) -> void:
	if is_shaking: shake()


func _on_DurationTimer_timeout() -> void:
	end_shake()
