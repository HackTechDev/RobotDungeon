
extends CanvasLayer


func show():
	get_node("Menu").show()
	get_tree().set_pause(true)


func hide():
	get_node("Menu").hide()
	get_tree().set_pause(false)


func _ready():
	hide()


func _on_Continue_pressed():
	hide()


func _on_MainMenu_pressed():
	get_tree().set_pause(false)
	yield(get_tree(), "idle_frame")
	get_tree().change_scene("res://scenes/main_menu.scn")


