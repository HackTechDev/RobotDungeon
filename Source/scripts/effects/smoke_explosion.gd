
extends Particles2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_emitting(true)
	get_node("SamplePlayer2D").play("explosion")


func _on_Timer_timeout():
	queue_free()


