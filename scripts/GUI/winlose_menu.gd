
extends CanvasLayer


func show():
	get_node("Menu").show()


func hide():
	get_node("Menu").hide()


func _ready():
	hide()


func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_MainMenu_pressed():
	get_tree().change_scene("res://scenes/main_menu.scn")


