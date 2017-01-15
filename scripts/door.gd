
extends StaticBody2D

var playerClass = preload("res://scripts/player.gd")
var buttonDoor = preload("res://sprites/door_button.png")
var bossDoor = preload("res://sprites/door_boss.png")

export var leftFacing = false setget set_left_facing
export var button_only = false
export var boss = false

var disabled = false

func door_disable():
	if not disabled:
		disabled = true
		get_node("Sprite").hide()
		set_collision_mask(64)
		set_layer_mask(64)
		get_node("SamplePlayer2D").play("dooropen")


func set_left_facing(val):
	leftFacing = val
	if leftFacing:
		set_scale(Vector2(-1, 1))
	else:
		set_scale(Vector2(1, 1))


func _ready():
	if button_only:
		get_node("Sprite").set_texture(buttonDoor)
	
	if boss:
		get_node("Sprite").set_texture(bossDoor)


func _on_Area2D_body_enter(body):
	if not button_only:
		if not disabled:
			if body extends playerClass:
				if get_node("/root/global").get_keys() > 0:
					get_node("/root/global").add_keys(-1)
					door_disable()


