extends KinematicBody2D

export var id = 1
export var team = 1
const is_trop = true
var destine
var nextPoint
var speed = 50
var state
var path = []
var units = []
var initialize = false

func _ready():
	GC.connect("change_unit_goto",self,"set_goto")
	GC.connect("low_update",self,"low_update")
	GC.connect("upper_low_update",self,"recheck_enemy")
#	$Vision.connect("body_entered",self,"recheck_enemy")
#	$Vision.connect("body_exited",self,"recheck_enemy")
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

func recheck_enemy():
	var enemies = []
	var team_enem = 2
	if team == 2: team_enem = 1
	for en in get_tree().get_nodes_in_group("group_unit_team_"+str(team_enem)):
		if position.distance_to(en.position) < 150: enemies.append(en)
	if enemies.size() <= 0: return
	var asign_index = 0;
	for un in units:
		if un.enemy_target: continue
		else:
			un.set_enemy(enemies[asign_index])
			if !enemies[asign_index].enemy_target: enemies[asign_index].set_enemy(un)
			asign_index += 1
			if asign_index == enemies.size(): asign_index = 0

func low_update():
	$Sprite.flip_h = (position.x > nextPoint.x)
	z_index = position.y + 2
	$Light2D.texture_scale = .5+randf()*.03
	$Light2D.texture_scale = .5+randf()*.03
	$Light2D.energy = 1-randf()*.03
	recheck_enemy()
	if !initialize && units.size()>0: initialize = true
	if initialize && units.size() == 0: queue_free()

func set_state(new_state):
	if(state == new_state): return
	state = new_state
	$AnimationPlayer.play(new_state)
