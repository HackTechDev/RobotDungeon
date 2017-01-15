
extends RigidBody2D

var smokeEffectScene = preload("res://scenes/effects/smoke_explosion_small.scn")
var playerClass = preload("res://scripts/player.gd")

var is_friendly = true setget set_friendly, get_friendly
var direction = Vector2(0, 1)
var speed = 200

var disabled = false


func set_friendly(friendly=true):
	is_friendly = friendly


func get_friendly():
	return is_friendly


func fire(dir):
	direction = dir.normalized()
	direction.y *= 0.5
	apply_impulse(get_pos(), direction * speed)


func disable():
	if not disabled:
		disabled = true
		
		var eff = smokeEffectScene.instance()
		get_parent().add_child(eff)
		eff.set_pos(get_pos())
		
		queue_free()


func _ready():
	pass


func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var cc = state.get_contact_collider_object(i)
		if cc:
			disable()


func _on_Hit_Detection_area_enter(area):
	if not disabled:
		if is_friendly:
			if area.is_in_group("Enemy Damage Area"):
				area.get_parent().take_damage(get_pos())
				disable()
			
			if area.is_in_group("Pot Damage Area"):
				area.get_parent().take_damage()
				disable()
		else:
			if area.is_in_group("Player Damage Area"):
				area.get_parent().take_damage()
				disable()


