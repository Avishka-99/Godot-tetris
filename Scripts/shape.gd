extends KinematicBody2D
onready var DelayYaxix :=$DelayY
onready var DelayTimer :=$Delay
#onready var coll = $CollisionPolygon2D
var speed =500
var x
var velocity = Vector2.ZERO
var rotate_counterClockWise=[]
func _ready():
	rotate_counterClockWise.append([2,3])
	print(rotate_counterClockWise)
func _process(delta):
	#print(coll.get_global_position())
	#print(position.x)
	if DelayTimer.is_stopped():
		print("Timer Stopped")
	velocity.y=1
	if Input.is_action_pressed("ui_left") and DelayTimer.is_stopped():
		position.x-=64
		DelayTimer.start(0.1)
	if Input.is_action_pressed("ui_right")and DelayTimer.is_stopped():
		position.x+=64
		DelayTimer.start(0.1)
		#print("Timer Started")
	if Input.is_action_pressed("ui_up"):
		velocity.y=-0.1
		#set_global_position(Vector2(0,32))
		for child in get_children():
			#child.set_global_position(Vector2(0,0))
			if child.name=="Sprite":
				child.queue_free()
				set_global_position(Vector2(0,0))
				#x=child.get_global_position()
				#child.set_global_position(Vector2(0,0))
				#print(x)
	
	move_and_slide(speed*velocity*delta)
	
	if Input.is_action_just_released("ui_left"):
		velocity.x=0
	if Input.is_action_just_released("ui_right"):
		velocity.x=0
