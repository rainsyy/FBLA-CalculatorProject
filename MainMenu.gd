extends Control

var first = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	MusicController.play_music()

func _on_start_button_button_up():
	$MenuSound.play()
	get_tree().change_scene_to_file("res://Calculator.tscn")
	
