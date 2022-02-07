extends Node

signal change_unit_goto
signal low_update
signal upper_low_update

var trop_selected = 0
var units_from_team = [[],[],[],[],[]]
var selected_element = null
var types_units = {
	"soldier": preload("res://assets/unit3.png"),
	"archer": preload("res://assets/unit4.png"),
	"barbarien": preload("res://assets/unit5.png"),
	"huruk-hai": preload("res://assets/unit6.png"),
}

var options = {
	hp_bar_visible = true
}

onready var Map = get_node("/root/Main/Map")
onready var Cursor = get_node("/root/Main/Cursor")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var timer_low = Timer.new()
	timer_low.set_wait_time(.1)
	timer_low.connect("timeout", self, "low_update")
	get_node("/root/Main").add_child(timer_low)
	timer_low.start()
	
	var timer_upper_low = Timer.new()
	timer_upper_low.set_wait_time(1)
	timer_upper_low.connect("timeout", self, "upper_low_update")
	get_node("/root/Main").add_child(timer_upper_low)
	timer_upper_low.start()

func low_update(): emit_signal("low_update")
func upper_low_update(): emit_signal("upper_low_update")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func check_enemy_in_range(unit):
	var i = 0;
	var min_dist = 999999;
	var objetive = null;
	for team_array in units_from_team:
		if i==unit.team: continue
		for enemy in team_array:
			var dist = (unit.position as Vector2).distance_to(enemy.position)
			if(dist<min_dist): 
				min_dist = dist
				objetive = enemy

func select_element(elem):
	selected_element = elem
	Cursor.position.y = -9999
