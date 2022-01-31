extends Control

var unit_prefab = preload("res://prefab/KUnit.tscn")

func _ready():
	$Camera2D/CanvasLayer/UI/btn_start.connect("button_down",self,"onClick",["start"])
	for i in range(15):
		var un = unit_prefab.instance()
		un.trop_id = 1
		un.type_unit = "soldier"
		un.position = Vector2(200+i*30,400)
		$Map/Units.add_child(un)
	
	for i in range(5):
		var un = unit_prefab.instance()
		un.trop_id = 2
		un.type_unit = "archer"
		un.position = Vector2(750+i*30,400)
		$Map/Units.add_child(un)

func _process(delta):
	pass

func onClick(arg):
	if arg == "start": GC.emit_signal("change_unit_goto")
