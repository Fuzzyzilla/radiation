extends Node2D
tool

export(int) var frame setget set_frame
export(bool) var flip_h setget set_flip_h

const skin_colors = [
	0x8d5524ff,
	0xc68642ff,
	0xe0ac69ff,
	0xf1c27dff,
	0xffdbacff
]
const hair_colors = [
	0xa2826dff,
	0xd19f7eff,
	0x733a2fff,
	0x6f4a2fff,
	0x785c4eff,
	0xb39573ff,
	0x413026ff,
	0xc9aa95ff,
	0x654835ff,
	0xd69498ff,
	0x830404ff
]

onready var chosen_hair : Sprite = $Hair

func set_frame(new_frame :int):
	frame = new_frame
	if not has_node("Body"): return
	
	$Body.frame = frame
	$Hair2.frame = frame if frame < 10 else 1
	$Hair.frame = frame if frame < 10 else 1
	$Hair.frame = frame if frame < 10 else 1
	$Skin.frame = frame

func set_flip_h(new_flip_h :bool):
	flip_h = new_flip_h
	if not has_node("Body"): return
	
	$Body.flip_h = flip_h
	$Hair2.flip_h = flip_h
	$Hair.flip_h = flip_h
	$Hair.flip_h = flip_h
	$Skin.flip_h = flip_h

func choose():
	if randi() & 1 == 1:
		$Hair.visible = true
		$Hair2.visible = false
	else:
		$Hair.visible = false
		$Hair2.visible = true
	
	$Skin.self_modulate = Color(rand_from_array(skin_colors))
	$Hair.self_modulate = Color(rand_from_array(hair_colors))
	$Hair2.self_modulate = Color(rand_from_array(hair_colors))
	
	set_flip_h(randi() & 1 == 1)

func rand_from_array(array : Array):
	return array[rand_range(0, array.size())]
	
func _ready():
	randomize()
	choose()
