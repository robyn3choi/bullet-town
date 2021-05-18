extends HBoxContainer

func _on_Health_health_changed(health) -> void:
	for i in range(get_child_count()):
		var heart = get_child(i)
		
		if i + 1 <= health:
			heart.set_value(1)
		elif health - i > 0:
			heart.set_value(health - i) # this will be a decimal value
		else:
			heart.set_value(0)
			
