extends ProgressBar

func _on_Bar_value_changed(value):
	visible = not value >= max_value
