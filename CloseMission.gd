extends Area2D

signal thanks_ended

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		.hide()
		$ordi_clic.play()
		emit_signal("thanks_ended")

