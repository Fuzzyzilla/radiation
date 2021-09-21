extends AudioStreamPlayer

export(bool) var enabled = true

func _on_StartAnimation_finished():
	if enabled: play()
