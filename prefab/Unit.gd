extends KinematicBody2D

var destine
var nextPoint
var path = []
var state
var speed = 80
export var trop_id = 1
export var team = 1
export var type_unit = "soldier"
var trop
var enemy_target = null
var ignore_enemy = false
var reload_atack = 0
var reload_vel = 5
var hp = 25
var hpm = 25
var atk_damage = 5
var atackers = 0


func _ready():
	$AnimationPlayer.play("idle")
	randomize()
	reload_vel += rand_range(0,2)
	GC.units_from_team[team].append(self)
	GC.connect("low_update",self,"low_update")
	$Vision.connect("body_entered",self,"recheck_enemy")
	$Vision.connect("body_exited",self,"recheck_enemy")
	$Sprite.texture = GC.types_units[type_unit]
	destine = position
	nextPoint = position
	if trop: trop.units.append(self)
	$prgBar.visible = GC.options.hp_bar_visible
	$prgBar.value = hp
	$prgBar.max_value = hpm
	move_and_slide(Vector2.ZERO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vecGoto = (nextPoint - position)
	if vecGoto.length() > 35: 
		set_state("walk")
		move_and_slide(vecGoto.normalized() * speed)
	else: 
		if(path.size() > 1):
			nextPoint = path[1]
			path.remove(0)
		else:
			set_state("idle")

	if enemy_target && position.distance_to(enemy_target.position) < 50 && reload_atack >= 100:
		reload_atack -= 100
		enemy_target.damage(self)
		print("ATACK ENEMY!!")

func set_state(new_state):
	if(state == new_state): return
	state = new_state
#	if state == "walk": $CollisionShape2D.shape.radius = 5
#	else: $CollisionShape2D.shape.radius = 15
	$AnimationPlayer.play(new_state)

func check_goto():
	if !enemy_target || ignore_enemy:
		if(trop and destine != trop.nextPoint): 
			destine = trop.nextPoint
	else: 
		if(position.distance_to(enemy_target.position)<20) : return
		destine = enemy_target.position
	
#	print("GET PATH ",randf())
	path = (GC.Map as Navigation2D).get_simple_path(position,destine,false)
	if(path.size()>=1): nextPoint = path[0]
#	(GC.Map.get_node("Line2D") as Line2D).points = path

func low_update():
	$Sprite.flip_h = (position.x > nextPoint.x)
	z_index = position.y
	check_goto()
	if reload_atack < 100: reload_atack += reload_vel

func recheck_enemy(body=null):
#	print("recheck_enemy.. ",randf())
	enemy_target = null
	for en in $Vision.get_overlapping_bodies():
		if !en.get("type_unit"): continue
		if en.team == team: continue
		if en.hp <= 0: continue
		enemy_target = en
		break
		
#func _on_custom_Area2D_body_entered(body):
#	if !body.get("type_unit"): return
##	if team != 1: return
#	if enemy_target != null && enemy_target.atackers <= body.atackers: return
#	if body.team == team: return
#	enemy_target = body
#	enemy_target.atackers += 1
#	print(enemy_target)

#func _on_custom_Area2D_body_exited(body):
#	if !body.get("type_unit"): return
##	if team != 1: return
#	if enemy_target == body: 
#		enemy_target.atackers -= 1
#		enemy_target = null
#		print(enemy_target)

func damage(enemy):
	if !enemy_target: enemy_target = enemy
	hp -= enemy.atk_damage
	$prgBar.value = hp
	$Tween.interpolate_property($Sprite,"modulate",Color(1,.3,.3,1),Color(1,1,1,1),.4,Tween.TRANS_EXPO,Tween.EASE_IN)
	$Tween.start()
	if hp <= 0: 
		queue_free()
		if trop: trop.units.remove( trop.units.find(self) )
		enemy.recheck_enemy()
		if enemy.trop: for un in enemy.trop.units: un.recheck_enemy()
