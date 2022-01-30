extends Node2D

export var id = 1
var units = []

func _ready():
	GC.connect("change_unit_goto",self,"set_goto")

func set_goto(pos):
	if(GC.trop_selected!=id): return
	if(pos): position = pos
	else: position = Vector2(rand_range(0,1024), rand_range(0,600))
