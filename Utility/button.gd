extends Button

signal  click_end()

func _on_mouse_entered():
	pass
	#$Hover.play()

func _on_pressed():
	print("pressed")
	_on_click_finished()
	#$Click.play()

func _on_click_finished():
	emit_signal("click_end")
