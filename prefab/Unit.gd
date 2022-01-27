extends Node2D

var goto = position
var path
var state
var speed = 30

func _ready():
	$AnimationPlayer.play("idle")
	randomize()
	GC.connect("change_unit_goto",self,"set_goto")
	GC.connect("low_update",self,"low_update")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vecGoto = (goto - position)
	if vecGoto.length() > 50: 
		set_state("walk")
		position += vecGoto.normalized() * delta * speed		
	else: 
		set_state("idle")

func set_state(new_state):
	if(state == new_state): return
	state = new_state
	$AnimationPlayer.play(new_state)

func set_goto():
	var destine = Vector2(rand_range(50,1024), rand_range(50,600))
	path = (GC.Map as Navigation2D).get_simple_path(position,destine)
	goto = path[1]
	(GC.Map.get_node("Line2D") as Line2D).points = path


func low_update():
	$Sprite.flip_h = (position.x > goto.x)
	z_index = position.y
	$Light2D.texture_scale = .5+randf()*.01
	$Light2D.energy = 1-randf()*.02
