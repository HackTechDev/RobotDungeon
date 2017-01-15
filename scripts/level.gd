extends Navigation2D

var hiddenWalls = []
var checkCells = [Vector2(0, 1), Vector2(1, 1), Vector2(1, 0)]

var objectsNode


func _ready():
	set_process(true)
	objectsNode = get_node("Objects")


func _process(delta):
	#Hide walls
	var newHiddenWalls = []
	var objects = get_tree().get_nodes_in_group("HideWalls")
	for i in range(objects.size()):
		var obj = objects[i]
		var pos = Vector2()
		for i in range(3):
			pos = objectsNode.world_to_map(obj.get_pos() + obj.get_node("GroundOffset").get_pos()) + checkCells[i]
			if objectsNode.get_cell(pos.x, pos.y) == 1 or objectsNode.get_cell(pos.x, pos.y) == 2:
				if newHiddenWalls.find(pos) == -1:
					newHiddenWalls.append(pos)
					objectsNode.set_cell(pos.x, pos.y, 2)
				
				if hiddenWalls.find(pos) != -1:
					hiddenWalls.erase(pos)
	
	for i in range(hiddenWalls.size()):
		var pos = hiddenWalls[i]
		objectsNode.set_cell(pos.x, pos.y, 1)
	
	hiddenWalls = newHiddenWalls



