extends RigidBody2D

export(int) var max_health = 10
const point_value = 15

onready var health = max_health

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthBar.max_value = max_health
	$HealthBar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func die():
	var slime_scene = preload("res://Slime2.tscn")
	var slime = slime_scene.instance();
	slime.global_position = global_position
	get_parent().add_child(slime)
	
	var sound_scene = preload("res://ExplosionSound.tscn")
	var sound = sound_scene.instance()
	sound.global_position = global_position
	get_parent().add_child(sound)
	
	var points_scene = preload("res://Points.tscn")
	var points = points_scene.instance()
	points.global_position = global_position
	points.value = point_value
	get_parent().add_child(points)
	
	get_tree().call_group("Camera","shake", 1)
	queue_free()

func _on_HitArea_hit():
	health-=1
	$HealthBar.value = health
	if health == 0:
		call_deferred("die")
