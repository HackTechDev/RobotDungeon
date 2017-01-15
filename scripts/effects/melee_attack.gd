
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	pass


func set_effect_rot(ang):
	get_node("Axis").set_rot(ang)


func set_fast(isFast):
	if isFast:
		get_node("AnimationPlayer").play("move fast")


func effectEnd():
	queue_free()

