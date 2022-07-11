extends KinematicBody2D
onready var timer:=$DelayCanMoveDown

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func time():
	print("hello")
	timer.start(0.01)
	if timer.is_stopped():
		print("hello")
func _ready():
	time() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
