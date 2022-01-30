extends KinematicBody2D

var goto = position
var destine = position
var path
var state
var speed = 80
export var trop_id = 1
onready var trop = GC.Map.get_node("Trop"+str(trop_id))

func _ready():
	$AnimationPlayer.play("idle")
	randomize()
	GC.connect("low_update",self,"low_update")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!trop): return
	var vecGoto = (goto - position)
	if vecGoto.length() > 10: 
		set_state("walk")
		move_and_slide(vecGoto.normalized() * speed)
#		position += vecGoto.normalized() * delta * speed
	else: 
		if(path.size() > 1):
			goto = path[1]
			path.remove(0)
		else:
			set_state("idle")

func set_state(new_state):
	if(state == new_state): return
	state = new_state
	$AnimationPlayer.play(new_state)

func check_goto():
	if(!trop): return
	if(destine == trop.position): return
	destine = trop.position
	path = (GC.Map as Navigation2D).get_simple_path(position,destine)
	goto = path[0]
	(GC.Map.get_node("Line2D") as Line2D).points = path

func low_update():
	$Sprite.flip_h = (position.x > goto.x)
	z_index = position.y
	$Light2D.texture_scale = .5+randf()*.01
	$Light2D.energy = 1-randf()*.02
	check_goto()
