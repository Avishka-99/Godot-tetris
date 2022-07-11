extends Node2D
var xCordinates = [72, 136, 200, 264, 328, 392, 456, 520, 584, 648]
var yCordinates = [32,96,160,224,288,352,416,480,544,608,672,736,800,864,928,992,1056,1120,1184,1248]
var Lshape =preload("res://Scenes/Lshape.tscn")
var Ishape =preload("res://Scenes/Ishape.tscn")
var Oshape =preload("res://Scenes/Oshape.tscn")
var Zshape =preload("res://Scenes/Zshape.tscn")
var gameOver = preload("res://Scenes/GameOver.tscn")
var controlButtons = preload("res://Scenes/ControlButtons.tscn")
onready var scoreLabel = $Background/Label
var shapesArray=[Lshape,Ishape,Oshape,Zshape]
var xIndex
var yIndex
var count=0
var scene
var blockDirection = "horizontal"
var hasActiveBlock=false
var blockPositions=[]
var score=0
func _ready():
	Engine.set_target_fps(0)
	randomize()
	var control = controlButtons.instance()
	add_child(control)
	scoreLabel.set_text(str(score))
	for x in 20:
		blockPositions.append([0,0,0,0,0,0,0,0,0,0])
	add_block()
	Signals.connect("hasActive",self,"has_active_block")
func moveDownRemainingBlocks(y):
	for x in range(y,-1,-1):
		var yCordinate=yCordinates[x]
		var nextY=yCordinates[x+1]
		for child in get_children():
			if (child is KinematicBody2D) and !(child is StaticBody2D) and !(child is Sprite):
				for child2 in get_node(child.name).get_children():
					if child2 is Sprite or child2 is CollisionShape2D:
						if child2.get_global_position().y==yCordinate:
							child2.set_global_position(Vector2(child2.get_global_position().x,nextY))
func removeBlocks(y):
	var yValue = yCordinates[y]
	for child in get_children():
		if (child is KinematicBody2D) and !(child is StaticBody2D) and !(child is Sprite):
			for child2 in get_node(child.name).get_children():
				if child2 is Sprite or child2 is CollisionShape2D:
					if child2.get_global_position().y==yValue:
						child2.queue_free()
	score+=1
	scoreLabel.set_text(str(score))
	moveDownRemainingBlocks(y-1)
func check_completedLines():
	for x in range(0,20,1):
		if blockPositions[x].find(0)==-1:
			removeBlocks(x)
			#print(x)
		else:
			pass
func checkGameOver(scene):
	for child in scene.get_children():
		if child is Sprite:
			yIndex=yCordinates.find(int(round(child.get_global_position().y)))
			if yIndex==0:
				var game_over=gameOver.instance()
				add_child(game_over)
				get_tree().paused=true
func add_block():
	var num =randi()%4
	var shape=shapesArray[num]
	scene=shape.instance()
	scene.position= Vector2(264,32)
	add_child(scene)
	has_active_block(true)
	blockDirection="horizontal"
func has_active_block(status):
	hasActiveBlock=status
func resetArray():
	for i in 20:
		for j in 10:
			blockPositions[i][j]=0
func updateBlockPosition(x,y):
	xIndex=xCordinates.find(x)
	yIndex=yCordinates.find(y)
	blockPositions[yIndex][xIndex]=1
	Signals.emit_signal("blockPosition",blockPositions)
func showArr():
	for t in 20:
		print(blockPositions[t])
	print("\n")
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		if blockDirection=="horizontal":
			blockDirection="vertical"
		else:
			blockDirection="horizontal"
	if !hasActiveBlock:
		checkGameOver(scene)
		check_completedLines()
		add_block()
	resetArray()
	for child in get_children():
		if (child is KinematicBody2D) and !(child is StaticBody2D) and !(child is Sprite):
			for kid in get_node(child.name).get_children():
				if kid is Sprite:
					updateBlockPosition(int(round(kid.get_global_position().x)),int(round(kid.get_global_position().y)))
	#showArr()
	
