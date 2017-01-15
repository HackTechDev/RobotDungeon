
extends CanvasLayer

onready var keysNode = get_node("Keys/Label")
onready var healthBarNode = get_node("Health/Bar")


func update_HUD():
	keysNode.set_text("x" + str(get_node("/root/global").get_keys()))
	
	var width = get_parent().health * 4
	healthBarNode.set_region_rect(Rect2(0, 0, width, 12))


func _ready():
	set_process(true)


func _process(delta):
	update_HUD()


