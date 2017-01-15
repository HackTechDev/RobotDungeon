
extends Control


onready var Anim = get_node("AnimationPlayer")
onready var SP = get_node("SamplePlayer")

var defualtScreenScale = Vector2(512, 300)
var curScale = 2


func _ready():
	var SoundS = get_node("Options/Sound/Sound Scroll")
	var MusicS = get_node("Options/Music/Music Scroll")
	var ScaleS = get_node("Options/Scale/Scale Scroll")
	
	SoundS.set_value(int(AudioServer.get_fx_global_volume_scale() * 10))
	MusicS.set_value(int(AudioServer.get_stream_global_volume_scale() * 10))
	
	curScale = clamp(floor(OS.get_window_size().y / 300), 1, 3)
	ScaleS.set_value(curScale)
	
	OS.set_window_size(defualtScreenScale * curScale)


func _on_Start_pressed():
	SP.play("button")
	get_tree().change_scene("res://scenes/main.scn")


func _on_Options_pressed():
	SP.play("button")
	Anim.play("to options")


func _on_Info_pressed():
	SP.play("button")
	Anim.play("to info")


func _on_Quit_pressed():
	SP.play("button")
	get_tree().quit()


func _on_Options_Back_pressed():
	SP.play("button")
	Anim.play_backwards("to options")


func _on_Sound_Scroll_value_changed( value ):
	var lbl = get_node("Options/Sound")
	lbl.set_text("Sound Effects: " + str(value))
	
	AudioServer.set_fx_global_volume_scale(value / 10.0)


func _on_Music_Scroll_value_changed( value ):
	var lbl = get_node("Options/Music")
	lbl.set_text("Music: " + str(value))
	
	AudioServer.set_stream_global_volume_scale(value / 10.0)


func _on_Scale_Scroll_value_changed( value ):
	var lbl = get_node("Options/Scale")
	lbl.set_text("Screen Scale: " + str(value))
	curScale = int(value)


func _on_Scale_Button_pressed():
	SP.play("button")
	OS.set_window_size(defualtScreenScale * curScale)


func _on_Controls_Back_pressed():
	SP.play("button")
	Anim.play_backwards("to info")


