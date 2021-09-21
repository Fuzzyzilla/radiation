extends Node2D

signal finished

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shake(size : float):
	$Shake.interpolate_property($Chamber, "position:x", -size, 0, 0.25, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Shake.start()
	get_tree().call_group("Camera", "shake", int(abs(size/2)))
	$Sound.volume_db = size
	$Sound.play()

func break_out():
	var chamber = $Chamber
	remove_child(chamber)
	chamber.global_position = global_position
	get_parent().add_child(chamber)
	chamber.die()
	
	emit_signal("finished")
	
	queue_free()
