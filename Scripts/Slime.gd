extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const speed = 20
const min_fling_delay = 1
const max_fling_delay = 1.5

var can_fling = true
var fling_destination : Vector2

var offscreen_arrow : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var fling_delay = rand_range(min_fling_delay, max_fling_delay)
	$FlingTimer.wait_time = fling_delay
	$FlingCooldown.max_value = fling_delay


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(_delta):
	var can_move = $Sprite/AnimationPlayer.current_animation == "Idle"
	var moving = Input.is_action_pressed("ui_move")
	var fling = Input.is_action_pressed("ui_shoot")
	
	if can_move and moving:
		var destination = get_global_mouse_position()
		var vector = destination - global_position
		var distance = vector.length()
		
		var velocity = vector.normalized() * min(distance, speed)
		velocity += get_avoidance()
		
		var _discard = move_and_slide(velocity, Vector2(0,0), false, 4, deg2rad(45), true)
		$Sprite.flip_h = vector.x < 0
	
	if can_fling and fling:
		$Sprite/AnimationPlayer.play("Fling")
		can_fling = false
		fling_destination = get_global_mouse_position()
		var vector = fling_destination - global_position
		$Sprite.flip_h = vector.x < 0
	
	$FlingCooldown.visible = not $FlingTimer.is_stopped()
	$FlingCooldown.value = $FlingTimer.wait_time - $FlingTimer.time_left

func get_avoidance() -> Vector2:
	var accum = Vector2()
	for i in get_tree().get_nodes_in_group("Slimes"):
		if i == self: continue
		
		var vec_to = i.global_position - global_position
		accum -= 30 * vec_to / vec_to.length_squared()
	return accum

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Build" or anim_name == "Fling":
		$Sprite/AnimationPlayer.play("Idle");
	if anim_name == "Collapse":
		visible = false
		queue_free()

func _on_fling():
	var fling_scene = preload("res://Fling.tscn")
	var fling = fling_scene.instance()
	fling.global_position = $"Fling Location".global_position
	fling.direction = (fling_destination - $"Fling Location".global_position).normalized()
	fling.creator = self
	get_parent().add_child(fling)
	$FlingTimer.start()
	

func _on_can_fling():
	can_fling = true;


func _on_VisibilityNotifier_screen_entered():
	#destroy our arrow
	if offscreen_arrow != null:
		offscreen_arrow.queue_free()

func _on_VisibilityNotifier_screen_exited():
	#should be exactly one layer
	var layers = get_tree().get_nodes_in_group("PointerLayer")
	if layers.empty():
		return #????
		
	#create an arrow
	var arrow_scene = preload("res://Pointer.tscn")
	offscreen_arrow = arrow_scene.instance()
	offscreen_arrow.point_to = self
	
	var pointer_layer = layers[0]
	pointer_layer.add_child(offscreen_arrow)
