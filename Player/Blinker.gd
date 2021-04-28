extends Node

onready var blink_timer = $BlinkTimer
onready var duration_timer = $DurationTimer
var body: Node2D

func start_blinking(body, duration):
	self.body = body
	duration_timer.wait_time = duration
	duration_timer.start()
	blink_timer.start()


func _on_BlinkTimer_timeout() -> void:
	body.visible = !body.visible

func _on_DurationTimer_timeout() -> void:
	blink_timer.stop()
	body.visible = true
