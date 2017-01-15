
extends Area2D

var playerClass = preload("res://scripts/player.gd")
var active = true


func _ready():
	# Initialization here
	pass


func _on_Health_body_enter( body ):
	if active:
		if body extends playerClass:
			var healed = body.heal()
			if healed:
				active = false
				queue_free()


