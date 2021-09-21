extends RigidBody2D

enum BREAKABLE_TYPE {beaker, computer}
export(BREAKABLE_TYPE) var type
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Beaker.frame = 0
	$Computer.frame = 0
	if type == BREAKABLE_TYPE.beaker:
		$Beaker.visible = true
	else:
		$Beaker.visible = false
	$Computer.visible = not $Beaker.visible

func die():
	$HitArea/CollisionShape2D.disabled = true
	

func _on_HitArea_hit():
	$Beaker.frame = 1
	$Computer.frame = 1
	
	var sound_scene = preload("res://ExplosionSound.tscn")
	var sound = sound_scene.instance()
	sound.global_position = global_position
	get_parent().add_child(sound)
	
	get_tree().call_group("Camera", "shake", 0)
	
	call_deferred("die")
