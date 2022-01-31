extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = position.y
	var TM = GC.Map.get_node("TileMap") as TileMap
#	yield(get_tree().create_timer(2),"timeout")
	var tile_pos = TM.world_to_map(position)
	position = TM.map_to_world(tile_pos) + TM.cell_size/2
	TM.set_cell(tile_pos.x,tile_pos.y,2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
