extends KinematicBody2D

export var id = 1
const is_trop = true
var destine
var nextPoint
var speed = 50
var state
var path = []
var units = []

func _ready():
	GC.connect("change_unit_goto",self,"set_goto")
	GC.connect("low_update",self,"low_update")
	destine = position
	nextPoint = position

func set_goto(pos):
	print("SET GOTO TROP")
	if(GC.trop_selected!=self): return
	destine = pos
	path = (GC.Map as Navigation2D).get_simple_path(position,destine,false)
	if(path.size()>=1): nextPoint = path[0]
	(GC.Map.get_node("Line2D") as Line2D).points = path

func _process(delta):
	var vecGoto = (nextPoint - position)
	if vecGoto.length() > 40: 
		set_state("walk")
		move_and_slide(vecGoto.normalized() * speed)
	else: 
		if(path.size() > 1):
			nextPoint = path[1]
			path.remove(0)
		else:
			set_state("idle")

func low_update():
	$Sprite.flip_h = (position.x > nextPoint.x)
	z_index = position.y + 2
	$Light2D.texture_scale = .5+randf()*.03
	$Light2D.texture_scale = .5+randf()*.03
	$Light2D.energy = 1-randf()*.03

func set_state(new_state):
	if(state == new_state): return
	state = new_state
	$AnimationPlayer.play(new_state)
