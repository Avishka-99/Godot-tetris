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
var rotate_counterClockWise=[[64,0],[0,64],[0,128]]
var rotate_clockWise=[[0,64],[-64,0],[-128,0]]
var clockwise=false
var collision
var arr=[]
var blockDirection="vertical"
var xCordinates = [72, 136, 200, 264, 328, 392, 456, 520, 584, 648]
var yCordinates = [32,96,160,224,288,352,416,480,544,608,672,736,800,864,928,992,1056,1120,1184,1248]
var horizontalIndexes=[[0,0],[0,0],[0,0],[0,0]]
var verticalIndexes=[[0,0],[0,0],[0,0],[0,0]]
var isJustChangedOrientation=false
var vertical=false
var xIndex
var yIndex
var key=null
var timerState=false
func initializeHorizontalIndexArray():
	for x in 3:
		horizontalIndexes.append([0,0])
func initializeVerticalIndexArray():
	for x in 4:
		verticalIndexes.append([0,0])
func canRotateClockwise():
	var rotateArr=[]
	var indexArr=[]
	var value=0
	var sprite1xCordinate=$Sprite1.get_global_position().x
	var sprite1YCordinate=$Sprite1.get_global_position().y
	for child in get_children():
		if child is Sprite:
				removePrePosition(xCordinates.find(int(round(child.get_global_position().x))),yCordinates.find(int(round(child.get_global_position().y)))) 
	for x in 3:
		indexArr.append([xCordinates.find(int(round(sprite1xCordinate+rotate_clockWise[x][0]))),yCordinates.find(int(round(sprite1YCordinate+rotate_clockWise[x][1])))])
	if(indexArr[0][0]<2):
		value=2-indexArr[0][0]
		indexArr[0][0]+=value
		indexArr[1][0]=indexArr[0][0]-1
		indexArr[2][0]=indexArr[1][0]-1
	for x in 3:
		if(arr[indexArr[x][1]][indexArr[x][0]]==0):
			rotateArr.append(true)
		else:
			rotateArr.append(false)
		if x==0 and arr[indexArr[x][1]-1][indexArr[x][0]+1]==0:
			rotateArr.append(true)
		elif x==0 and arr[indexArr[x][1]-1][indexArr[x][0]+1]==1:
			rotateArr.append(false)
	if rotateArr.find(false)!=-1:
		return [false,value]
	else:
		return [true,value]
func canRotateCounterClockwise():
	var rotateArr=[]
	var indexArr=[]
	var value=0
	var sprite1xCordinate=$Sprite1.get_global_position().x
	var sprite1YCordinate=$Sprite1.get_global_position().y
	for child in get_children():
		if child is Sprite:
				removePrePosition(xCordinates.find(int(round(child.get_global_position().x))),yCordinates.find(int(round(child.get_global_position().y)))) 
	for x in 3:
		indexArr.append([xCordinates.find(int(round(sprite1xCordinate+rotate_counterClockWise[x][0]))),yCordinates.find(int(round(sprite1YCordinate+rotate_counterClockWise[x][1])))])
	if(indexArr[1][0]==9):
		value=584
		indexArr[0][0]=9
		indexArr[1][0]=8
		indexArr[2][0]=8
	else:
		value=0
	for x in 3:
		if(arr[indexArr[x][1]][indexArr[x][0]]==0):
			rotateArr.append(true)
		else:
			rotateArr.append(false)
		if x==0 and arr[indexArr[x][1]][indexArr[x][0]-1]==0:
			rotateArr.append(true)
		elif x==0 and arr[indexArr[x][1]][indexArr[x][0]-1]==1:
			rotateArr.append(false)
	if rotateArr.find(false)!=-1:
		return [false,value]
	else:
		return [true,value]
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
func removeVerticalOrHorizontalPrePosition(x,y,key):
	if key=="left":
		arr[y][x+1]=0
	elif key=="right":
		arr[y][x-1]=0
	elif key=="idle":
		arr[y-1][x]=0
func updateVerticalOrHorizontalPrePosition(x,y):
	xIndex=xCordinates.find(int(round(x)))
	yIndex=yCordinates.find(int(round(y)))
	arr[yIndex+1][xIndex]=1
func removePrePosition(x,y):
	arr[y][x]=0
func updateArr(x,y,key):
	arr[y][x]=1
func showArr():
	for t in 20:
		print(arr[t])
	print("===============================================================")
	
func canMoveDown():
	var ar=[]
	if is_in_group("Lshape"):
		if blockDirection=="horizontal":
			for child in get_children():
				if child is Sprite and (child.name=="Sprite2" or child.name=="Sprite3" or child.name=="Sprite4"):
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (yIndex<19 and arr[yIndex+1][xIndex]==0) and (child.name=="Sprite2" or child.name=="Sprite3" or child.name=="Sprite4"):
						ar.append(true)
					else:
						ar.append(false)
		else:
			for child in get_children():
				if child is Sprite and child.name=="Sprite4" or child.name=="Sprite2":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					#print(str(xIndex)+","+str(yIndex))
					if (yIndex<19 and arr[yIndex+1][xIndex]==0) and (child.name=="Sprite4" or child.name=="Sprite2"):
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
					updateArr(xCordinates.find(int(round(child.get_global_position().x))),xCordinates.find(int(round(child.get_global_position().y))),"none")
			return false
func canMoveLeft():
	var ar=[true]
	if is_in_group("Lshape"):
		ar.clear()
		if blockDirection=="horizontal":
			for child in get_children():
				if child is Sprite:
					if child.name=="Sprite2" or child.name=="Sprite4":
						xIndex=xCordinates.find(int(round(child.get_global_position().x)))
						yIndex=yCordinates.find(int(round(child.get_global_position().y)))
						if (xIndex>0 and arr[yIndex][xIndex-1]==0):
							ar.append(true)
						else:
							ar.append(false)
		else:
			for child in get_children():
				if child is Sprite and child.name=="Sprite1" or child.name=="Sprite3" or child.name=="Sprite4":
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
	if is_in_group("Lshape"):
		ar.clear()
		if blockDirection=="horizontal":
			for child in get_children():
				if child is Sprite and child.name=="Sprite1" or child.name=="Sprite2":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (xIndex<9 and arr[yIndex][xIndex+1]==0):
						ar.append(true)
					else:
						ar.append(false)
		else:
			for child in get_children():
				if child is Sprite and child.name=="Sprite2" or child.name=="Sprite3" or child.name=="Sprite4":
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
			key="idle"
			isJustChangedOrientation=false
			position.y+=64
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			DelayYTimer.start(0.8)
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
			position.y+=64
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			key="idle"
		if Input.is_action_pressed("ui_accept"):
			_print_child_global_positions()
		if Input.is_action_just_pressed("ui_up") and !blocked:
			isJustChangedOrientation=true
			if blockDirection=="vertical":
				var canRotate=canRotateClockwise()
				if canRotate[0]:
					blockDirection="horizontal"
					vertical=false
					set_rotation(PI/2)
					position=Vector2(int(round(get_global_position().x))+int(round(canRotate[1]*64)),int(round(get_global_position().y)))
			else:
				var canRotate=canRotateCounterClockwise()
				if canRotate[0]:
					blockDirection="vertical"
					vertical=true
					set_rotation(2*PI)
					if(canRotate[1]>0):
						position=Vector2(canRotate[1],int(round(get_global_position().y)))
					else:
						position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
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
						updateArr(horizontalIndexes[x][0],horizontalIndexes[x][1],"none")
				else:
					for x in 4:
						removePrePosition(horizontalIndexes[x][0],horizontalIndexes[x][1])
					for x in 4:
						updateArr(verticalIndexes[x][0],verticalIndexes[x][1],"none")
			else:
				if key=="left":
					if blockDirection=="horizontal":
						for x in 4:
							removeVerticalOrHorizontalPrePosition(horizontalIndexes[x][0],horizontalIndexes[x][1],"left")
						for x in 4:
							updateArr(horizontalIndexes[x][0],horizontalIndexes[x][1],"left")
					else:
						for x in 4:
							removeVerticalOrHorizontalPrePosition(verticalIndexes[x][0],verticalIndexes[x][1],"left")
						for x in 4:
							updateArr(verticalIndexes[x][0],verticalIndexes[x][1],"left")
				elif key=="right":
					if blockDirection=="horizontal":
						for x in 4:
							removeVerticalOrHorizontalPrePosition(horizontalIndexes[x][0],horizontalIndexes[x][1],"right")
						for x in 4:
							updateArr(horizontalIndexes[x][0],horizontalIndexes[x][1],"right")
					else:
						for x in 4:
							removeVerticalOrHorizontalPrePosition(verticalIndexes[x][0],verticalIndexes[x][1],"right")
						for x in 4:
							updateArr(verticalIndexes[x][0],verticalIndexes[x][1],"right")
				elif key=="idle":
					if blockDirection=="horizontal":
						for x in 4:
							removeVerticalOrHorizontalPrePosition(horizontalIndexes[x][0],horizontalIndexes[x][1],"idle")
						for x in 4:
							updateArr(horizontalIndexes[x][0],horizontalIndexes[x][1],"idle")
					else:
						for x in 4:
							removeVerticalOrHorizontalPrePosition(verticalIndexes[x][0],verticalIndexes[x][1],"idle")
						for x in 4:
							updateArr(verticalIndexes[x][0],verticalIndexes[x][1],"idle")
			count+=1
			if((collision.collider is StaticBody2D) and collision.collider.name=="Bottom"):
				#_print_child_global_positions()
				Signals.emit_signal("hasActive",false)
				isActive=false
				blocked=true
			elif(collision.collider is KinematicBody2D):
				blocked=canMoveDown()
				if !blocked:
					Signals.emit_signal("hasActive",true)
					isActive=true
					position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
				else:
					Signals.emit_signal("hasActive",false)
					isActive=false
					position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
		else:
			Signals.emit_signal("hasActive",true)
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			#print("not collide")
		
		if Input.is_action_just_released("ui_left"):
			velocity.x=0
		if Input.is_action_just_released("ui_right"):
			velocity.x=0
	else:
		pass
