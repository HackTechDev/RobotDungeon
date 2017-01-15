
extends Area2D

var playerClass = preload("res://scripts/player.gd")
var bossKey = preload("res://sprites/key_boss.png")

export var boss = false


func _ready():
	if boss:
		get_node("Sprite").set_texture(bossKey)


func _on_Key_body_enter( body ):
	if body extends playerClass:
		body.got_key()
		get_node("/root/global").add_keys(1)
		queue_free()


