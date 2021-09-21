extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const velo_damping = 0.05

var velocity = Vector2(0,0)

const shake_damping = 0.2
const speed = 60
var current_amount = 0

var enable_movement = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	
	if not enable_movement:
		return
	
	var vertical = 0
	var horizontal = 0
	
	var win_size = get_viewport_rect().size
	var margin = 0.15 * win_size
	
	var max_edge = win_size - margin
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	if mouse_pos.x < margin.x:
		horizontal = -1
	elif mouse_pos.x > max_edge.x:
		horizontal = 1
	if mouse_pos.y < margin.y:
		vertical = -1
	elif mouse_pos.y > max_edge.y:
		vertical = 1
	
	velocity = lerp(velocity, Vector2(horizontal, vertical), velo_damping)
	
	position += velocity * speed * delta
	
	var half_size = get_viewport_rect().size * scale / 2
	
	position.x = clamp(position.x, limit_left + half_size.x, limit_right - half_size.x)
	position.y = clamp(position.y, limit_top + half_size.y, limit_bottom - half_size.y)

func shake(size):
	var amount = 0
	var time = 0
	match size:
		0:
			amount = 1
			time = 0.5
		1:
			amount = 3
			time = 0.5
		_:
			amount = 7
			time = 0.8
			
	if amount >= current_amount:
		current_amount = amount
		$Shake.interpolate_property(self, "offset:x", amount, 0, time, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$Shake.interpolate_property(self, "offset:y", -amount, 0, time * 0.8, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$Shake.start()

func _on_Shake_tween_all_completed():
	current_amount = 0


func _on_StartAnimation_finished():
	enable_movement = true
