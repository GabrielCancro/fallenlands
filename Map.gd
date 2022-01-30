extends Navigation2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	_add_obstacle($Obstacle1)
	pass # Replace with function body.


func _add_obstacle(OBSTACLE):
	$NavMesh.enabled = false
	var new_polygon = PoolVector2Array()
	var col_polygon =OBSTACLE.get_node("CollisionPolygon2D").get_polygon()
	for vector in col_polygon:
		new_polygon.append(vector + OBSTACLE.position)
	$NavMesh.get_navigation_polygon().add_outline(new_polygon)
	$NavMesh.get_navigation_polygon().make_polygons_from_outlines()
	$NavMesh.enabled = true
