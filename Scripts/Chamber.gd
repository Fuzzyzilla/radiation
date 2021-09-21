extends StaticBody2D

export(bool) var is_large = false

const big_health = 10
const small_health = 5

const big_points = 20
const small_points = 10

var point_value

var health

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("BigBubble" if is_large else "SmallBubble")
	health = big_health if is_large else small_health
	point_value = big_points if is_large else small_points
	$Bar.max_value = health

func die():
	health = 0
	
	$Sprite.visible = false
	$Sprite/AnimationPlayer.stop()
	$Broken.visible = true
	$HitArea/CollisionShape2D.disabled = true
	
	var slime_scene = preload("res://Slime2.tscn")
	
	var rand_bool = randi() & 1 == 1
	var spawn1 = $Spawn1 if rand_bool else $Spawn2
	var spawn2 = $Spawn2 if rand_bool else $Spawn1
	
	var slime = slime_scene.instance();
	slime.global_position = spawn1.global_position
	get_parent().add_child(slime)
	if is_large:
		slime = slime_scene.instance();
		slime.global_position = spawn2.global_position
		get_parent().add_child(slime)
		
	
	var sound_scene = preload("res://ExplosionSound.tscn")
	var sound = sound_scene.instance()
	sound.global_position = global_position
	get_parent().add_child(sound)
	
	get_tree().call_group("Camera","shake", 2 if is_large else 1)
	
	var points_scene = preload("res://Points.tscn")
	var points = points_scene.instance()
	points.global_position = global_position
	points.value = point_value
	get_parent().add_child(points)

func _on_HitArea_hit():
	health -= 1
	$Bar.value = health
	if health == 0:
		call_deferred("die")
