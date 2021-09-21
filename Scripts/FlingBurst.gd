extends CPUParticles2D

func _ready():
	emitting = true
	$Timer.wait_time = lifetime

func _on_Timer_timeout():
	queue_free()
