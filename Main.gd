extends Control

var unit_prefab = preload("res://prefab/KUnit.tscn")

func _ready():
	$Camera2D/CanvasLayer/UI/btn_start.connect("button_down",self,"onClick",["start"])
	for i in range(15):
		yield(get_tree().create_timer(.1),"timeout")
		var un = unit_prefab.instance()
		un.trop_id = 1
		un.team = 1
		un.type_unit = "soldier"
		un.trop = $Map/Units/Trop
		un.position = un.trop.position
		$Map/Units.add_child(un)
	
	for i in range(10):
		var un = unit_prefab.instance()
		un.trop_id = 2
		un.team = 2
		un.type_unit = "archer"
		un.trop = $Map/Units/Trop2
		un.position = un.trop.position
		$Map/Units.add_child(un)

func _process(delta):
	pass

func onClick(arg):
	if arg == "start": GC.emit_signal("change_unit_goto")
