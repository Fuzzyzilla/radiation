extends KinematicBody2D

const calm_threshold = 30
const scared_threshold = 50
const speed = 30
const walk_speed = 20
const point_value = 20

const min_walk_delay = 1
const max_walk_delay = 5
const min_walk_duration = 1
const max_walk_duration = 2

var health = 5

var nearby_threshold = calm_threshold

var walk_direction : Vector2

var is_walking = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthBar.max_value = health

func _process(_delta):
	var nearby : Array = find_nearby_danger()
	if not nearby.empty():
		is_walking = false
		$WalkTimer.stop()
		
		nearby_threshold = scared_threshold
		
		#run away
		play_or_continue("Run")
		var direction_vec = Vector2(0,0)
		for hazard in nearby:
			direction_vec -= hazard[1] / hazard[1].length_squared()
		var _discard = move_and_slide(direction_vec.normalized() * speed)
		$ScientistSprite.flip_h = direction_vec.x > 0
	else:
		nearby_threshold = calm_threshold
		if $WalkTimer.is_stopped():
			$WalkTimer.start(rand_range(min_walk_delay, max_walk_delay))
		if is_walking:
			var _discard = move_and_slide(walk_direction * walk_speed)
			$ScientistSprite.flip_h = walk_direction.x > 0
		#vibe
		play_or_continue("Walk" if is_walking else "Idle")

func play_or_continue(anim_name : String):
	var anim_node = $ScientistSprite/AnimationPlayer
	if not anim_node.current_animation == anim_name:
		anim_node.play(anim_name)

func find_nearby_danger():
	var nearby = []
	for slime in get_tree().get_nodes_in_group("Slimes"):
		var vec_to = slime.global_position - global_position
		if vec_to.length_squared() < nearby_threshold * nearby_threshold:
			nearby.append([slime, vec_to])
	for fling in get_tree().get_nodes_in_group("Flings"):
		var vec_to = fling.global_position - global_position
		if vec_to.length_squared() < nearby_threshold * nearby_threshold:
			nearby.append([fling, vec_to])
	return nearby

func _on_HitArea_hit():
	health -= 1
	$HealthBar.value = health
	
	var burst_scene = preload("res://FlingBurst.tscn")
	var burst = burst_scene.instance()
	burst.color = Color(1,0,0,1)
	burst.global_position = global_position
	if health > 0:
		burst.amount /= 2
	get_parent().add_child(burst)
	
	if health == 0:
		var points_scene = preload("res://Points.tscn")
		var points = points_scene.instance()
		points.global_position = global_position
		points.value = point_value
		get_parent().add_child(points)
		
		queue_free()

func choose_direction():
	var angle = rand_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle))

func _on_WalkTimer_timeout():
	if is_walking:
		#stop walking
		is_walking = false
		$WalkTimer.start(rand_range(min_walk_delay, max_walk_delay))
	else:
		#start walking
		is_walking = true
		walk_direction = choose_direction()
		$WalkTimer.start(rand_range(min_walk_duration, max_walk_duration))
