extends Panel


func _input(event):
	if event.is_action_pressed("interact"):
		if position + size/2 > Vector2.ZERO and position + size/2 < get_viewport_rect().size:
			queue_free()
