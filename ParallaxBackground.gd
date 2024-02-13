extends ParallaxBackground

@export var bgspeed = -10
@export var thirdGroundSpeed = -25
@export var secondGroundSpeed = -35
@export var foregroundspeed = -65

@onready var foreGround = $ParallaxLayer
@onready var secondGround = $ParallaxLayer2
@onready var thirdGround = $ParallaxLayer3
@onready var backGround = $ParallaxLayer4

func _process(delta):
	foreGround.motion_offset.x += foregroundspeed * delta
	secondGround.motion_offset.x += secondGroundSpeed * delta
	thirdGround.motion_offset.x += thirdGroundSpeed * delta
	backGround.motion_offset.x += bgspeed * delta
