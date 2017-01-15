
extends RigidBody2D

var meleeEffectScene = preload("res://scenes/effects/melee_attack.scn")
var smokeEffectScene = preload("res://scenes/effects/smoke_explosion.scn")
var playerClass = preload("res://scripts/player.gd")

const AI_IDLE = 1
const AI_HUNT = 2
const AI_BLOCK = 4
const AI_ATTACK = 8
const AI_DAMAGED = 16

var AI_state = 1

var health = 18

var moveTarget = Vector2()
var points = []
var navTarget = Vector2()

var moveSpeed = 2.5

var scaleY = 0.5

var home = Vector2()
var target

var can_attack = true
var is_blocking = false

var hits = 0
var hitsMax = 6

var anim = "idle"
var facingLeft = false


func take_damage(origin, amnt=1):
	if not is_blocking:
		hits += 1
		if hits >= hitsMax:
			hits = 0
			AI_state = AI_BLOCK
			get_node("Block Timer").start()
			return
		else:
			health -= amnt
		
		if health <= 0:
			var eff = smokeEffectScene.instance()
			get_parent().add_child(eff)
			eff.set_pos(get_pos())
			
			get_node("/root/Game").set_state(get_node("/root/Game/").STATE_WIN)
			
			queue_free()
		else:
			moveTarget = (get_pos() - origin).normalized()
			AI_state = AI_DAMAGED
			get_node("Damaged Timer").start()
	
	else:
		get_node("SamplePlayer2D").play("bossblockhit")


func do_attack():
	if target:
		target.take_damage()
		can_attack = false
		AI_state = AI_ATTACK
		get_node("Attack Duration").start()
		get_node("Attack Cooldown").set_wait_time(0.75 + (randi()%2))
		get_node("Attack Cooldown").start()
		get_node("SamplePlayer2D").play("punch")


func get_move_point():
	points = get_parent().get_parent().get_simple_path(get_pos() + Vector2(0, 14), moveTarget, true)
	if points.size() > 1:
		#var offset = (points[1] - (get_pos() + Vector2(0, 14))).normalized() * 32
		return points[1] #+ offset
	
	return moveTarget


func _ready():
	set_fixed_process(true)
	
	home = get_pos()
	moveTarget = home


func _fixed_process(delta):
	var newAnim = "idle"
	var newFacingLeft = (get_linear_velocity().x < 0)
	if target:
		newFacingLeft = ((target.get_pos() - get_pos()).x < 0)
	
	var cur_pos = get_pos() + Vector2(0, 14)
	
	set_linear_velocity(get_linear_velocity() * 0.975)
	
	is_blocking = false
	
	var speed = get_linear_velocity().length()
	if speed > 8:
		newAnim = "move"
	
	#AI
	if AI_state == AI_IDLE:
		if target:
			var space_state = get_world_2d().get_direct_space_state()
			var ray = space_state.intersect_ray(cur_pos, target.get_pos() + Vector2(0, 14), [self], 1)
			
			if not ray.empty():
				if ray.collider:
					if ray.collider == target:
						AI_state = AI_HUNT
	
	elif AI_state == AI_HUNT:
		if target:
			var dis = (target.get_pos() - get_pos()).length()
			if dis > 64:
				moveTarget = target.get_pos() + Vector2(0, 14)
				
				var movepoint = get_move_point()
				var impulse = (movepoint - cur_pos).normalized() * moveSpeed
				impulse.y *= scaleY
				apply_impulse(cur_pos, impulse)
				
			else:
				if dis <= 32:
					moveTarget = target.get_pos() + Vector2(0, 14)
					
					var movepoint = get_move_point()
					var impulse = (cur_pos - movepoint).normalized() * moveSpeed
					impulse.y *= scaleY
					apply_impulse(cur_pos, impulse)
				
				if can_attack:
					do_attack()
			
			if target.get_dead():
				target = null
				AI_state = AI_IDLE
			
		else:
			AI_state = AI_IDLE
	
	elif AI_state == AI_BLOCK:
		is_blocking = true
		newAnim = "block"
	
	elif AI_state == AI_ATTACK:
		newAnim = "attack"
		
	
	elif AI_state == AI_DAMAGED:
		newAnim = "damaged"
		newFacingLeft = not (moveTarget.x < 0)
		
		get_node("Sprite").set_modulate(Color(1,1,1, 0.75 + (0.25 * sin(OS.get_ticks_msec() / 10))))
		
		var impulse = moveTarget * moveSpeed
		apply_impulse(cur_pos, impulse)
	
	#Facing
	if newFacingLeft != facingLeft:
		facingLeft = newFacingLeft
		if facingLeft:
			get_node("Sprite").set_scale(Vector2(-1, 1))
		else:
			get_node("Sprite").set_scale(Vector2(1, 1))
	
	#Animation
	if newAnim != anim:
		anim = newAnim
		get_node("Anim").play(anim)


func _on_Detection_body_enter( body ):
	if body extends playerClass:
		target = body


func _on_Detection_body_exit( body ):
	if body extends playerClass:
		target = null


func _on_Damaged_Timer_timeout():
	AI_state = AI_IDLE
	moveTarget = home
	get_node("Sprite").set_modulate(Color(1,1,1,1))


func _on_Attack_Duration_timeout():
	if randi()%2 == 1:
		AI_state = AI_IDLE
		moveTarget = home
	else:
		AI_state = AI_BLOCK
		get_node("Block Timer").start()


func _on_Attack_Cooldown_timeout():
	can_attack = true


func _on_Block_Timer_timeout():
	AI_state = AI_IDLE
	is_blocking = false


