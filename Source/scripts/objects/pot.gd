
extends StaticBody2D

var healthScene = preload("res://scenes/objects/heal.scn")

var destroyed = false

export var has_health = false


func take_damage():
	if not destroyed:
		destroyed = true
		get_node("AnimationPlayer").play("destroy")
		set_collision_mask(64)
		set_layer_mask(64)
		
		get_node("Damage Area").set_collision_mask(64)
		get_node("Damage Area").set_layer_mask(64)
		
		get_node("SamplePlayer2D").play("potbreak")
		
		if has_health:
			var item = healthScene.instance()
			item.set_pos(get_pos())
			get_parent().add_child(item)


func _ready():
	# Initialization here
	pass


