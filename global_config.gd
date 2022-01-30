extends Node

signal change_unit_goto
signal low_update
var trop_selected = 0

onready var Map = get_node("/root/Main/Map")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.set_wait_time(.1)
	timer.connect("timeout", self, "low_update")
	get_node("/root/Main").add_child(timer)
	timer.start()

func low_update():
	emit_signal("low_update")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
