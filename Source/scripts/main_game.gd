
extends Node

const STATE_PLAYING = 1
const STATE_WIN = 2
const STATE_LOSE = 4

var state = 1 setget set_state, get_state


func set_state(st):
	state = st
	if state == STATE_WIN:
		get_node("Win Menu").show()
		get_node("Level/Objects/Player").state = 4 #Win State
	
	elif state == STATE_LOSE:
		get_node("Lose Menu").show()


func get_state():
	return state


func _ready():
	set_process_input(true)
	get_node("/root/global").set_keys(0)
	randomize()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_node("Pause Menu").show()


