
extends Area2D

var playerClass = preload("res://scripts/player.gd")

export(NodePath) var doorPath
onready var doorNode = get_node(doorPath)

var activated = false


func _ready():
	pass


func _on_Button_body_enter( body ):
	if not activated:
		if body extends playerClass:
			activated = true
			doorNode.door_disable()
			get_node("AnimationPlayer").play("pressed")
			get_node("SamplePlayer2D").play("button")


