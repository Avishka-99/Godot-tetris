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
var key=null
var isJustChangedOrientation=false
var horizontalIndexes=[[0,0],[0,0],[0,0],[0,0]]
var verticalIndexes=[[0,0],[0,0],[0,0],[0,0]]

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
func removeVerticalOrHorizontalPrePosition(x,y,key):
	if key=="left":
		arr[y][x+1]=0
	elif key=="right":
		arr[y][x-1]=0
	elif key=="idle":
		arr[y-1][x]=0
		
func _ready():
	Signals.connect("blockPosition",self,"print_array")
	randomize()
func _relocate_collision_shape(child):
	collisionName=child.name.substr(0,6).to_lower()+child.name.substr(6)
func _rotate_counterClockWise(child):
	if child.name=="Sprite1":
		rotate_counterClockWise[0][0]=child.get_global_position().x
		rotate_counterClockWise[0][1]=child.get_global_position().y+128
	if child.name=="Sprite2":
		rotate_counterClockWise[1][0]=child.get_global_position().x-64
		rotate_counterClockWise[1][1]=child.get_global_position().y+64
	if child.name=="Sprite4":
		rotate_counterClockWise[2][0]=child.get_global_position().x-64
		rotate_counterClockWise[2][1]=child.get_global_position().y-64
func _rotate_ClockWise(child):
	if child.name=="Sprite1":
		rotate_clockWise[0][0]=child.get_global_position().x
		rotate_clockWise[0][1]=child.get_global_position().y-128
	if child.name=="Sprite2":
		rotate_clockWise[1][0]=child.get_global_position().x+64
		rotate_clockWise[1][1]=child.get_global_position().y-64
	if child.name=="Sprite4":
		rotate_clockWise[2][0]=child.get_global_position().x+64
		rotate_clockWise[2][1]=child.get_global_position().y+64
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
	
	if indexArr[0][0]>7:
		indexArr[0][0]=7
		indexArr[1][0]=8
		indexArr[2][0]=9
	#if indexArr[0][0]<0:
		#value=-indexArr[0][0]
		#for x in 3:
			#indexArr[x][0]+=value
	for x in 3:
		if(arr[indexArr[x][1]][indexArr[x][0]]==0):
			rotateArr.append(true)
		else:
			rotateArr.append(false)
		if x==1 and arr[indexArr[x][1]+1][indexArr[x][0]]==0:
			rotateArr.append(true)
		elif x==1 and arr[indexArr[x][1]+1][indexArr[x][0]]==1:
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
		if child.name.substr(0,6)=="Sprite" :
			print(child.name,child.get_global_position())
func print_array(array):
	arr=array
func removePrePosition(x,y):
	arr[y][x]=0
func removePrePosCollision(x,y):
	xIndex=xCordinates.find(x)
	yIndex=yCordinates.find(y)
	arr[yIndex][xIndex]=0
func updateArr(x,y,key):
	#print(x,y)
	arr[y][x]=1
func showArr():
	for t in 20:
		print(arr[t])
	print("===============================================================")
	
func canMoveDown():
	#showArr()
	var ar=[true]
	if is_in_group("Zshape"):
		ar.clear()
		if blockDirection=="horizontal":
			for child in get_children():
				#if child is Sprite:
					#print(child.name,child.position)
				if child is Sprite and child.name=="Sprite1" or child.name=="Sprite3" or child.name=="Sprite4":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (yIndex<19 and arr[yIndex+1][xIndex]==0):
						ar.append(true)
					else:
						ar.append(false)
		else:
			for child in get_children():
				if child is Sprite and child.name=="Sprite1" or child.name=="Sprite3":
					xIndex=xCordinates.find(int(round(child.get_global_position().x)))
					yIndex=yCordinates.find(int(round(child.get_global_position().y)))
					if (yIndex<19 and arr[yIndex+1][xIndex]==0):
						ar.append(true)
					else:
						ar.append(false)
		
		if ar.find(false)!=-1:
			return true
		else:
			
			for child in get_children():
				if child is Sprite:
					removePrePosition(xCordinates.find(int(round(child.get_global_position().x))),yCordinates.find(int(round(child.get_global_position().y)))) 
			for child in get_children():
				if child is Sprite:
					updateArr(xCordinates.find(int(round(child.get_global_position().x))),yCordinates.find(int(round(child.get_global_position().y))),null)
			return false
func canMoveLeft():
	var ar=[true]
	if is_in_group("Zshape"):
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
	if is_in_group("Zshape"):
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
			isJustChangedOrientation=false
			position.y+=64
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			DelayYTimer.start(0.8)
		#print(position.x)
		if Input.is_action_pressed("ui_left") and DelayXTimer.is_stopped() and isActive and position.x>72:
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
			isJustChangedOrientation=false
			position.y+=64
			key="idle"
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
		if Input.is_action_pressed("ui_accept"):
			_print_child_global_positions()
		if Input.is_action_just_pressed("ui_up") and !blocked:
			if clockwise:
				for child in get_children():
					_rotate_ClockWise(child)
				var canRotate=canRotateClockwise()
				#print(canRotate)
				if canRotate:
					blockDirection="horizontal"
					for child in get_children():
						if child.name=="Sprite1" or child.name=="sprite1":
							child.set_global_position(Vector2(rotate_clockWise[0][0],rotate_clockWise[0][1]))
						if child.name=="Sprite2" or child.name=="sprite2":
							child.set_global_position(Vector2(rotate_clockWise[1][0],rotate_clockWise[1][1]))
						if child.name=="Sprite4" or child.name=="sprite4":
							child.set_global_position(Vector2(rotate_clockWise[2][0],rotate_clockWise[2][1]))
					clockwise=false
					isJustChangedOrientation=true
					if position.x==584:
						position.x=520
			else:
				for child in get_children():
					_rotate_counterClockWise(child)
				var canRotate=canRotateCounterClockwise()
				#print(canRotate)
				if canRotate:
					blockDirection="vertical"
					for child in get_children():
						if child.name=="Sprite1" or child.name=="sprite1":
							child.set_global_position(Vector2(rotate_counterClockWise[0][0],rotate_counterClockWise[0][1]))
						if child.name=="Sprite2" or child.name=="sprite2":
							child.set_global_position(Vector2(rotate_counterClockWise[1][0],rotate_counterClockWise[1][1]))
						if child.name=="Sprite4" or child.name=="sprite4":
							child.set_global_position(Vector2(rotate_counterClockWise[2][0],rotate_counterClockWise[2][1]))
					clockwise=true
					isJustChangedOrientation=true
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
			#print(horizontalIndexes)
			#showArr()
		else:
			updateVerticalIndexes()
			#print(verticalIndexes)
			#showArr()
		if collision:
			#showArr()
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
						#print(horizontalIndexes)
						#showArr()
						for x in 4:
							removeVerticalOrHorizontalPrePosition(horizontalIndexes[x][0],horizontalIndexes[x][1],"left")
						#showArr()
						for x in 4:
							updateArr(horizontalIndexes[x][0],horizontalIndexes[x][1],"left")
						#showArr()
					else:
						#showArr()
						for x in 4:
							removeVerticalOrHorizontalPrePosition(verticalIndexes[x][0],verticalIndexes[x][1],"left")
						#showArr()
						for x in 4:
							updateArr(verticalIndexes[x][0],verticalIndexes[x][1],"left")
						#showArr()
				elif key=="right":
					if blockDirection=="horizontal":
						for x in 4:
							removeVerticalOrHorizontalPrePosition(horizontalIndexes[x][0],horizontalIndexes[x][1],"right")
						for x in 4:
							updateArr(horizontalIndexes[x][0],horizontalIndexes[x][1],"right")
					else:
						#showArr()
						for x in 4:
							removeVerticalOrHorizontalPrePosition(verticalIndexes[x][0],verticalIndexes[x][1],"right")
						#showArr()
						for x in 4:
							updateArr(verticalIndexes[x][0],verticalIndexes[x][1],"right")
						#showArr()
				elif key=="idle":
					if blockDirection=="horizontal":
						#print(horizontalIndexes)
						#showArr()
						for x in 4:
							removeVerticalOrHorizontalPrePosition(horizontalIndexes[x][0],horizontalIndexes[x][1],"idle")
						#showArr()
						for x in 4:
							updateArr(horizontalIndexes[x][0],horizontalIndexes[x][1],"idle")
						#showArr()
					else:
						for x in 4:
							removeVerticalOrHorizontalPrePosition(verticalIndexes[x][0],verticalIndexes[x][1],"idle")
						for x in 4:
							updateArr(verticalIndexes[x][0],verticalIndexes[x][1],"idle")
			#showArr()
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
			
			
			
			
			
			
			
			
			
			"""
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			for child in get_children():
				if child is Sprite:
					removePrePosCollision(int(round(child.get_global_position().x)),int(round(child.get_global_position().y))) 
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
					isActive=false"""
		else:
			position=Vector2(int(round(get_global_position().x)),int(round(get_global_position().y)))
			Signals.emit_signal("hasActive",true)
		
		if Input.is_action_just_released("ui_left"):
			velocity.x=0
		if Input.is_action_just_released("ui_right"):
			velocity.x=0
	else:
		pass
