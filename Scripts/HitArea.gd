extends Area2D

signal hit

func _on_hit():
	emit_signal("hit")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
