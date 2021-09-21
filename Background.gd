extends Control

onready var stopped = false setget set_stopped

func set_stopped(new_stopped):
	stopped = new_stopped
	$Viewport/CPUParticles2D.emitting = not stopped
	if not stopped:
		$Viewport/CPUParticles2D.restart()
	$Viewport.render_target_clear_mode = \
		Viewport.CLEAR_MODE_NEVER if stopped else Viewport.CLEAR_MODE_ALWAYS
	$Viewport.render_target_update_mode = \
		Viewport.UPDATE_DISABLED if stopped else Viewport.UPDATE_ALWAYS
