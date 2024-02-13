extends Node

var mainmusic = load("res://ludumdare38.ogg")
var first = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_music():
	if first == false:
		first = true
		$Music.stream = mainmusic
		$Music.play()
