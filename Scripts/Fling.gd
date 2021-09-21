extends Area2D

var direction : Vector2
var creator : Node

const speed = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	position += direction * speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func burst():
	var burst_scene = preload("res://FlingBurst.tscn")
	var burst = burst_scene.instance();
	burst.global_position = global_position
	get_parent().add_child(burst)
	
	var sound_scene = preload("res://HitSound.tscn")
	var sound = sound_scene.instance()
	sound.global_position = global_position
	get_parent().add_child(sound)
	
	get_tree().call_group("Camera","shake", 0)
	
	queue_free()

func _on_body_collision(body : Node2D):
	if body == creator:
		return
		
	if body.has_method("_on_hit"):
		body._on_hit()
	burst()

func _on_area_collision(area):
	if area.has_method("_on_hit"):
		area._on_hit()
	burst()
