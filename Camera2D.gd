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
			print("adasdasdasd")
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	if event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_Q:
			GC.emit_signal("change_unit_goto",get_viewport().get_mouse_position()+position-get_viewport().size/2)
