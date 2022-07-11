extends KinematicBody2D
onready var DelayYTimer :=$DelayY
onready var DelayXTimer :=$DelayX
onready var RotationTimer := $Rotation
onready var DelayCanMoveDown:=$DelayCanMoveDown
var mainScript = load("res://Scripts/Main.gd")
var collisionName
var blocked = false
var isActive = true
var count=0
var speed =0
var velocity = Vector2.ZERO
var rotate_counterClockWise=[[0,0],[0,0],[0,0]]
var rotate_clockWise=[[0,0],[0,0],[0,0]]
var clockwise=false
var collision
var arr=[]
var blockDirection="horizontal"
var xCordinates = [72, 136, 200, 264, 328, 392, 456, 520, 584, 648]
var yCordinates = [32,96,160,224,288,352,416,480,544,608,672,736,800,864,928,992,1056,1120,1184,1248]
var xIndex
var yIndex
var timerState=false
func _ready():
	Signals.connect("blockPosition",self,"print_array")
func _relocate_collision_shape(child):
	collisionName=child.name.substr(0,6).to_lower()+child.name.substr(6)
func _remove_collision_shape(name):
	for child in get_children():
		if child.name==name:
			child.queue_free()
func _print_child_global_positions():
	for child in get_children():
		if child.name.substr(0,6)=="Sprite" :
			print(child.name,child.get_global_position())
func print_array(array):
	arr=array
func removePrePosition(x,y):
	xIndex=xCordinates.find(x)
	yIndex=yCordinates.find(y)
	arr[yIndex-1][xIndex]=0
func updateArr(x,y):
	xIndex=xCordinates.find(x)
	yIndex=yCordinates.find(y)
	arr[yIndex][xIndex]=1
func showArr():
	for t in 20:
		print(arr[t])
	print("===============================================================")
	
func canMoveDown():
	var ar=[true]
	if is_in_group("Oshape"):
		ar.clear()
		for child in get_children():
			if child is Sprite:
				xIndex=xCordinates.find(int(round(child.get_global_position().x)))
				yIndex=yCordinates.find(int(round(child.get_global_position().y)))
				if(child.name=="Sprite3" or child.name=="Sprite4"):
					if (yIndex<19 and arr[yIndex+1][xIndex]==0):
						ar.append(true)
					else:
						ar.append(false)
		if ar.find(false)!=-1:
			return true
		else:
			for child in get_children():
				if child is Sprite:
					removePrePosition(int(round(child.get_global_position().x)),int(round(child.get_global_position().y))) 
			for child in get_children():
				if child is Sprite:
					updateArr(int(round(child.get_global_position().x)),int(round(child.get_global_position().y)))
			return false
func canMoveLeft():
	var ar=[true]
	if is_in_group("Oshape"):
		ar.clear()
		if blockDirection=="horizontal":
			for child in get_children():
				if child is Sprite and child.name=="Sprite1" or child.name=="Sprite3":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (xIndex>0 and arr[yIndex][xIndex-1]==0):
						ar.append(true)
					else:
						ar.append(false)
		else:
			for child in get_children():
				if child is Sprite and child.name=="Sprite1" or child.name=="Sprite2" or child.name=="Sprite4":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (xIndex>0 and arr[yIndex][xIndex-1]==0):
						ar.append(true)
					else:
						ar.append(false)
		if ar.find(false)!=-1:
			return false
		else:
			return true
func canMoveRight():
	var ar=[true]
	if is_in_group("Oshape"):
		ar.clear()
		if blockDirection=="horizontal":
			for child in get_children():
				if child is Sprite and child.name=="Sprite2" or child.name=="Sprite4":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (xIndex<9 and arr[yIndex][xIndex+1]==0):
						ar.append(true)
					else:
						ar.append(false)
		else:
			for child in get_children():
				if child is Sprite and child.name=="Sprite1" or child.name=="Sprite3" or child.name=="Sprite4":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (xIndex<9 and arr[yIndex][xIndex+1]==0):
						ar.append(true)
					else:
						ar.append(false)
		if ar.find(false)!=-1:
			return false
		else:
			return true
func _process(delta):
	if position.y>1184:
		position.y=1184
	if !blocked:
		velocity.y=0
		if DelayYTimer.is_stopped() and !Input.is_action_pressed("ui_down"):
			position.y+=64
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			DelayYTimer.start(0.8)
		if Input.is_action_pressed("ui_left") and DelayXTimer.is_stopped() and isActive and position.x>72:
			DelayXTimer.start(0.1)
			if(canMoveLeft()):
				position.x-=64
				position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
		if Input.is_action_pressed("ui_right")and DelayXTimer.is_stopped() and isActive:
			if(canMoveRight()):
				position.x+=64
				position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			DelayXTimer.start(0.1)
		if Input.is_action_just_pressed("ui_down"):
			position.y+=64
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
		if Input.is_action_pressed("ui_accept"):
			_print_child_global_positions()
		if Input.is_action_pressed("ui_home") and isActive:
			position.y=-64
			for child in get_children():
				if child.name=="Sprite1":
					child.queue_free()
					collisionName=child.name.substr(0,6).to_lower()+child.name.substr(6)
					_remove_collision_shape(collisionName)
		collision=move_and_collide(speed*velocity*delta)
		if collision:
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			for child in get_children():
				if child is Sprite:
					removePrePosition(int(round(child.get_global_position().x)),int(round(child.get_global_position().y))) 
			for child in get_children():
				if child is Sprite:
					updateArr(int(round(child.get_global_position().x)),int(round(child.get_global_position().y)))
			count+=1
			if((collision.collider is StaticBody2D) and collision.collider.name=="Bottom"):
				Signals.emit_signal("hasActive",false)
				isActive=false
				blocked=true
			elif(collision.collider is KinematicBody2D):
				blocked=canMoveDown()
				if !blocked:
					Signals.emit_signal("hasActive",true)
					isActive=true
				else:
					Signals.emit_signal("hasActive",false)
					isActive=false
		else:
			Signals.emit_signal("hasActive",true)
		if Input.is_action_just_released("ui_left"):
			velocity.x=0
		if Input.is_action_just_released("ui_right"):
			velocity.x=0
	else:
		pass
