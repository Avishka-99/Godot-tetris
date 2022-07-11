extends KinematicBody2D
onready var DelayYTimer :=$DelayY
onready var DelayXTimer :=$DelayX
onready var RotationTimer := $Rotation
onready var DelayCanMoveDown:=$DelayCanMoveDown
var mainScript = load("res://Scripts/Main.gd")
var collisionName
var blocked = false
var isActive = true
var canMoveOrRotate=true
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
var horizontalIndexes=[[0,0],[0,0],[0,0],[0,0]]
var verticalIndexes=[]
var isJustChangedOrientation=false
var vertical=false
var xIndex
var yIndex
var timerState=false
var key=null
func initializeHorizontalIndexArray():
	for x in 3:
		horizontalIndexes.append([0,0])
func initializeVerticalIndexArray():
	for x in 4:
		verticalIndexes.append([0,0])
func _relocate_collision_shape(child):
	collisionName=child.name.substr(0,6).to_lower()+child.name.substr(6)
func _rotate_counterClockWise(child):
	if child.name=="Sprite1":
		rotate_counterClockWise[0][0]=child.get_global_position().x+64
		rotate_counterClockWise[0][1]=child.get_global_position().y+64
	if child.name=="Sprite3":
		rotate_counterClockWise[1][0]=child.get_global_position().x-64
		rotate_counterClockWise[1][1]=child.get_global_position().y-64
	if child.name=="Sprite4":
		rotate_counterClockWise[2][0]=child.get_global_position().x-128
		rotate_counterClockWise[2][1]=child.get_global_position().y-128
func _rotate_ClockWise(child):
	if child.name=="Sprite1":
		rotate_clockWise[0][0]=child.get_global_position().x-64
		rotate_clockWise[0][1]=child.get_global_position().y-64
	if child.name=="Sprite3":
		rotate_clockWise[1][0]=child.get_global_position().x+64
		rotate_clockWise[1][1]=child.get_global_position().y+64
	if child.name=="Sprite4":
		rotate_clockWise[2][0]=child.get_global_position().x+128
		rotate_clockWise[2][1]=child.get_global_position().y+128
func canRotateClockwise():
	for child in get_children():
		if child is Sprite:
				removePrePosition(xCordinates.find(int(round(child.get_global_position().x))),yCordinates.find(int(round(child.get_global_position().y)))) 
	var rotateArr=[]
	var indexArr=[]
	var value=0
	for x in 3:
		var xCordinate=int(round(rotate_clockWise[x][0]))
		var yCordinate=int(round(rotate_clockWise[x][1]))
		indexArr.append([xCordinates.find(xCordinate),yCordinates.find(yCordinate)])
	if indexArr[0][0]<0:
		value=-indexArr[0][0]
		for x in 3:
			indexArr[x][0]+=value
	for x in 3:
		if(arr[indexArr[x][1]][indexArr[x][0]]==0):
			rotateArr.append(true)
		else:
			rotateArr.append(false)
		if x==0 and arr[indexArr[x][1]][indexArr[x][0]+1]==0:
			rotateArr.append(true)
		elif x==0 and arr[indexArr[x][1]][indexArr[x][0]+1]==1:
			rotateArr.append(false)
	if rotateArr.find(false)!=-1:
		return false
	else:
		return true
func canRotateCounterClockwise():
	for child in get_children():
		if child is Sprite:
				removePrePosition(xCordinates.find(int(round(child.get_global_position().x))),yCordinates.find(int(round(child.get_global_position().y)))) 
	var rotateArr=[]
	var indexArr=[]
	var value=0
	for x in 3:
		var xCordinate=int(round(rotate_counterClockWise[x][0]))
		var yCordinate=int(round(rotate_counterClockWise[x][1]))
		indexArr.append([xCordinates.find(xCordinate),yCordinates.find(yCordinate)])
	if indexArr[0][0]<0:
		value=-indexArr[0][0]
		for x in 3:
			indexArr[x][0]+=value
	for x in 3:
		if(arr[indexArr[x][1]][indexArr[x][0]]==0):
			rotateArr.append(true)
		else:
			rotateArr.append(false)
		if x==0 and arr[indexArr[x][1]][indexArr[x][0]+1]==0:
			rotateArr.append(true)
		elif x==0 and arr[indexArr[x][1]][indexArr[x][0]+1]==1:
			rotateArr.append(false)
	if rotateArr.find(false)!=-1:
		return false
	else:
		return true
func _remove_collision_shape(name):
	for child in get_children():
		if child.name==name:
			child.queue_free()
func _print_child_global_positions():
	for child in get_children():
		if child is CollisionShape2D :
			print(child.name,child.get_global_position())
func print_array(array):
	arr=array
func removeVerticalOrHorizontalPrePosition(x,y):
	arr[y-1][x]=0
func updateVerticalOrHorizontalPrePosition(x,y):
	xIndex=xCordinates.find(int(round(x)))
	yIndex=yCordinates.find(int(round(y)))
	arr[yIndex+1][xIndex]=1
func removePrePosition(x,y):
	arr[y][x]=0
func updateArr(x,y):
	arr[y][x]=1
func showArr():
	for t in 20:
		print(arr[t])
func canMoveDown():
	var ar=[]
	if is_in_group("Ishape"):
		if blockDirection=="horizontal":
			for child in get_children():
				if child is Sprite:
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (yIndex<19 and arr[yIndex+1][xIndex]==0) and (child.name=="Sprite1" or child.name=="Sprite2" or child.name=="Sprite3" or child.name=="Sprite4" ):
						ar.append(true)
					else:
						ar.append(false)
		else:
			for child in get_children():
				if child is Sprite and child.name=="Sprite1":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (yIndex<19 and arr[yIndex+1][xIndex]==0) and (child.name=="Sprite1"):
						ar.append(true)
					else:
						ar.append(false)
		if ar.find(false)!=-1:
			return true
		else:
			for child in get_children():
				if child is Sprite:
					removePrePosition(xCordinates.find(int(round(child.get_global_position().x))),xCordinates.find(int(round(child.get_global_position().y)))) 
			for child in get_children():
				if child is Sprite:
					updateArr(xCordinates.find(int(round(child.get_global_position().x))),xCordinates.find(int(round(child.get_global_position().y))))
			return false
func canMoveLeft():
	var ar=[true]
	if is_in_group("Ishape"):
		ar.clear()
		if blockDirection=="horizontal":
			for child in get_children():
				if child is Sprite and child.name=="Sprite1":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (xIndex>0 and arr[yIndex][xIndex-1]==0):
						ar.append(true)
					else:
						ar.append(false)
		else:
			for child in get_children():
				if child is Sprite:
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
	if is_in_group("Ishape"):
		ar.clear()
		if blockDirection=="horizontal":
			for child in get_children():
				if child is Sprite and child.name=="Sprite4":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (xIndex<9 and arr[yIndex][xIndex+1]==0):
						ar.append(true)
					else:
						ar.append(false)
		else:
			for child in get_children():
				if child is Sprite:
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
func updateHorizontalIndexes():
	var index=0
	for child in get_children():
		if child is Sprite:
			xIndex=xCordinates.find(int(round(child.get_global_position().x)))
			yIndex=yCordinates.find(int(round(child.get_global_position().y)))
			horizontalIndexes[index][0]=xIndex
			horizontalIndexes[index][1]=yIndex
			index+=1
func updateVerticalIndexes():
	var index=0
	for child in get_children():
		if child is Sprite:
			xIndex=xCordinates.find(int(round(child.get_global_position().x)))
			yIndex=yCordinates.find(int(round(child.get_global_position().y)))
			verticalIndexes[index][0]=xIndex
			verticalIndexes[index][1]=yIndex
			index+=1
func _ready():
	Signals.connect("blockPosition",self,"print_array")
func _process(delta):
	if position.y>1248:
		position.y=1248
	if !blocked:
		velocity.y=0
		if DelayYTimer.is_stopped() and !Input.is_action_pressed("ui_down"):
			isJustChangedOrientation=false
			position.y+=64
			key="down"
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			DelayYTimer.start(0.8)

		if canMoveOrRotate==true:
			if Input.is_action_pressed("ui_left") and DelayXTimer.is_stopped() and isActive :
				DelayXTimer.start(0.1)
				if(canMoveLeft()):
					key="left"
					position.x-=64
					position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			if Input.is_action_pressed("ui_right")and DelayXTimer.is_stopped() and isActive:
				if(canMoveRight()):
					key="right"
					position.x+=64
					position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
				DelayXTimer.start(0.1)
			if Input.is_action_just_pressed("ui_down"):
				key="down"
				isJustChangedOrientation=false
				position.y+=64
				position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			if Input.is_action_pressed("ui_accept"):
				_print_child_global_positions()
			if Input.is_action_just_pressed("ui_up") and !blocked:
				isJustChangedOrientation=true
				if blockDirection=="horizontal":
					blockDirection="vertical"
					initializeVerticalIndexArray()
					vertical=true
				else:
					blockDirection="horizontal"
				if clockwise:
					for child in get_children():
						_rotate_ClockWise(child)
					var canRotate=canRotateClockwise()
					if canRotate:
						for child in get_children():
							if child.name=="Sprite1" or child.name=="sprite1":
								child.set_global_position(Vector2(rotate_clockWise[0][0],rotate_clockWise[0][1]))
							if child.name=="Sprite3" or child.name=="sprite3":
								child.set_global_position(Vector2(rotate_clockWise[1][0],rotate_clockWise[1][1]))
							if child.name=="Sprite4" or child.name=="sprite4":
								child.set_global_position(Vector2(rotate_clockWise[2][0],rotate_clockWise[2][1]))
						clockwise=!clockwise
						if position.x==584:
							position.x=520
						if(get_global_position().x<72):
							set_global_position(Vector2(72,get_global_position().y))
						elif(get_global_position().x>456):
							set_global_position(Vector2(456,get_global_position().y))
					else:
						blockDirection="vertical"
						isJustChangedOrientation=false
				else:
					for child in get_children():
						_rotate_counterClockWise(child)
					var canRotate=canRotateCounterClockwise()
					if canRotate:
						for child in get_children():
							if child.name=="Sprite1" or child.name=="sprite1":
								child.set_global_position(Vector2(rotate_counterClockWise[0][0],rotate_counterClockWise[0][1]))
							if child.name=="Sprite3" or child.name=="sprite3":
								child.set_global_position(Vector2(rotate_counterClockWise[1][0],rotate_counterClockWise[1][1]))
							if child.name=="Sprite4" or child.name=="sprite4":
								child.set_global_position(Vector2(rotate_counterClockWise[2][0],rotate_counterClockWise[2][1]))
						clockwise=!clockwise
						if(get_global_position().x<72):
							set_global_position(Vector2(72,get_global_position().y))
						elif(get_global_position().x>456):
							set_global_position(Vector2(456,get_global_position().y))
					else:
						blockDirection="horizontal"
						isJustChangedOrientation=false
			if Input.is_action_pressed("ui_home") and isActive:
				position.y=-64
				for child in get_children():
					if child.name=="Sprite1":
						child.queue_free()
						collisionName=child.name.substr(0,6).to_lower()+child.name.substr(6)
						_remove_collision_shape(collisionName)
		
		collision=move_and_collide(speed*velocity*delta)
		if blockDirection=="horizontal":
			updateHorizontalIndexes()
		else:
			updateVerticalIndexes()
		if collision:
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			if isJustChangedOrientation:
				if blockDirection=="horizontal":
					for x in 4:
						removePrePosition(verticalIndexes[x][0],verticalIndexes[x][1])
					for x in 4:
						updateArr(horizontalIndexes[x][0],horizontalIndexes[x][1])
				else:
					for x in 4:
						removePrePosition(horizontalIndexes[x][0],horizontalIndexes[x][1])
					for x in 4:
						updateArr(verticalIndexes[x][0],verticalIndexes[x][1])
			else:
				if blockDirection=="horizontal":
					for x in 4:
						removeVerticalOrHorizontalPrePosition(horizontalIndexes[x][0],horizontalIndexes[x][1])
					for x in 4:
						updateArr(horizontalIndexes[x][0],horizontalIndexes[x][1])
				else:
					for x in 4:
						removeVerticalOrHorizontalPrePosition(verticalIndexes[x][0],verticalIndexes[x][1])
					for x in 4:
						updateArr(verticalIndexes[x][0],verticalIndexes[x][1])
			count+=1
			if((collision.collider is StaticBody2D) and collision.collider.name=="Bottom"):
				canMoveOrRotate=false
				Signals.emit_signal("hasActive",false)
				isActive=false
				blocked=true
			elif(collision.collider is KinematicBody2D):
				blocked=canMoveDown()
				if !blocked:
					canMoveOrRotate=true
					Signals.emit_signal("hasActive",true)
					isActive=true
					position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
				else:
					canMoveOrRotate=false
					Signals.emit_signal("hasActive",false)
					isActive=false
					position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
		else:
			canMoveOrRotate=true
			Signals.emit_signal("hasActive",true)
		if Input.is_action_just_released("ui_left"):
			velocity.x=0
		if Input.is_action_just_released("ui_right"):
			velocity.x=0
	else:
		pass
