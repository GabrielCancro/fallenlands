extends Control

func _ready():
	$Camera2D/CanvasLayer/UI/btn_start.connect("button_down",self,"onClick",["start"])
	pass # Replace with function body.

func _process(delta):
	pass

func onClick(arg):
	if arg == "start": GC.emit_signal("change_unit_goto")
