extends StaticBody2D
tool

var health = 5

const point_value = 10

export(bool) var flip_h

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.frame = 0
	if flip_h:
		$Spawn.position.x *= -1
		$Sprite.flip_h = true
		$Sprite.offset.x = -5
	$Bar.max_value = health

func die():
	$Sprite/AnimationPlayer.play("Drip")
	$HitArea/CollisionShape2D.disabled = true
	
	var slime_scene = preload("res://Slime2.tscn")
	var slime = slime_scene.instance();
	slime.global_position = $Spawn.global_position
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

func _on_HitArea_hit():
	health -= 1
	$Bar.value = health
	if health == 0:
		call_deferred("die")
