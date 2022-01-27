extends Node2D

var goto

func _ready():
	$AnimationPlayer.play("idle")
	randomize()
	goto = Vector2(rand_range(50,1024), rand_range(50,600))
	print(goto)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vecGoto = (goto - position)
	if vecGoto.length() > 50: position += vecGoto.normalized() * delta * 200
	$Light2D.texture_scale = .5+randf()*.1
#	$Light2D.energy = .9+randf()*.2
