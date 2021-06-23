extends Node

onready var blink_timer = $BlinkTimer
onready var duration_timer = $DurationTimer
var bodies: Array

func start_blinking(bodies, duration):
	self.bodies = bodies
	duration_timer.wait_time = duration
	duration_timer.start()
	blink_timer.start()


func _on_BlinkTimer_timeout() -> void:
	for b in bodies:
		b.visible = !b.visible

func _on_DurationTimer_timeout() -> void:
	blink_timer.stop()
	for b in bodies:
		b.visible = true
