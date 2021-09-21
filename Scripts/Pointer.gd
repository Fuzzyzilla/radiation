extends Sprite

var point_to : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	var camera = get_tree().get_nodes_in_group("Camera")[0]
	if point_to == null:
		queue_free()
		return
	
	var vec_to = point_to.global_position - camera.global_position
	var screen_size = get_viewport_rect().size
	var screen_center = screen_size / 2
	var screen_radius = min(screen_center.x, screen_center.y)

	var angle_to = atan2(vec_to.y, vec_to.x)
	
#	var radius = min(screen_radius, vec_to.length())
#
#	var angle_top_right = atan2(-screen_center.y, screen_center.x)
#	var angle_top_left = atan2(-screen_center.y, -screen_center.x)
#
#	var x = 0
#	var y = 0
#	if angle > angle_top_right and angle < angle_top_left:
#		x = screen_center.y * tan(PI/2 - angle)
#		y = x * tan(angle)
#
#	print(x, ' ', y)
	
	global_position = vec_to.normalized() * screen_radius + screen_center
	rotation = angle_to
	
