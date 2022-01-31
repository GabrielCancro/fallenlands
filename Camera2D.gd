extends Camera2D

var mouse_start_pos
var screen_start_position
var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	position.x += 5

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var mouse_world = get_viewport().get_mouse_position() + position - get_viewport().size/2
			select_cursor( mouse_world )
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
			var el = GC.selected_element
			if(el && el.get("type_unit") && el.trop_id):
				GC.trop_selected = el.trop_id
				GC.emit_signal("change_unit_goto",mouse_world)
				GC.select_element(null)
		else:
			dragging = false
	if event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position

	
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_Q:
#			GC.trop_selected = 1
#			GC.emit_signal("change_unit_goto",get_viewport().get_mouse_position()+position-get_viewport().size/2)
#		if event.pressed and event.scancode == KEY_W:
#			GC.trop_selected = 2
#			GC.emit_signal("change_unit_goto",get_viewport().get_mouse_position()+position-get_viewport().size/2)

func select_cursor(pos):
	GC.Cursor.position = pos
	for body in (GC.Cursor as Area2D).get_overlapping_bodies():
		if(body.get("type_unit")):
			GC.select_element(body)
			break
	
