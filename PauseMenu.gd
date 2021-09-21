extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$SolidBackground.visible = false
	$SolidBackground/Backgroud.stopped = true
	if OS.has_feature("web"):
		$SolidBackground/CenterContainer/VBoxContainer/Quit.visible = false
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		paused = not paused
		
		$SolidBackground.visible = paused
		get_tree().paused = paused
		$SolidBackground/Backgroud.stopped = not paused


func _on_Fullscreen_pressed():
	OS.window_fullscreen = not OS.window_fullscreen


func _on_Quit_pressed():
	get_tree().quit()
