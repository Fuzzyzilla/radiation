extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("web"):
		$ColorRect/CenterContainer/VBoxContainer/Quit.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Fullscreen_pressed():
	$ClickSound.play()
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Quit_pressed():
	$ClickSound.play()
	get_tree().quit()


func _on_Play_pressed():
	$ClickSound.play()
	var _discard = \
		get_tree().change_scene_to(load("res://Room2.tscn"))
