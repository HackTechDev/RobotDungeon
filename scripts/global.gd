
extends Node

var playerKeys = 0 setget set_keys, get_keys


func set_keys(val):
	playerKeys = max(val, 0)


func add_keys(val):
	playerKeys = max(playerKeys + val, 0)


func get_keys():
	return playerKeys


func _ready():
	OS.set_window_size(OS.get_window_size() * 2)


