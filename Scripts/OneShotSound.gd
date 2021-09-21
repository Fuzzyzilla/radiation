extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	var _discard = connect("finished", self, "_finished")
	pass # Replace with function body.

func _finished():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
