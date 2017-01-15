
extends KinematicBody2D

var meleeEffectScene = preload("res://scenes/effects/melee_attack.scn")
var bulletScene = preload("res://scenes/bullet.scn")

const STATE_PLAYING = 1
const STATE_DEAD = 2
const STATE_WIN = 4

var state = 1

var movement = Vector2()
var velocity = Vector2()

var acc = 20
var dec = 60
var frc = 20
var top = 122

var scaleY = 0.5

var direction = Vector2(0, 1)
var leftFacing = false
var upFacing = false
var anim = "idle"

onready var animNode = get_node("Anim")
onready var soundNode = get_node("SamplePlayer")

var attacking = false
var can_attack = true
var shooting = false

var maxHealth = 10
var health = 10
var is_hurt = false


func take_damage(amnt=1):
	if health > 0 and not is_hurt:
		health = clamp(health - amnt, 0, maxHealth)
		
		if health <= 0:
			state = STATE_DEAD
			get_node("/root/Game").set_state(get_node("/root/Game/").STATE_LOSE)
			animNode.play("dead")
			
		
		else:
			is_hurt = true
			get_node("Damaged Timer").start()


func heal(amnt=2):
	if health < maxHealth:
		health = clamp(health + amnt, 0, maxHealth)
		soundNode.play("health")
		return true
	
	return false


func get_dead():
	return (state == STATE_DEAD)


func do_attack():
	var areas = get_node("AttackAxis/Punch").get_overlapping_areas()
	var punchhit = false
	for i in range(areas.size()):
		var target = areas[i]
		if target.is_in_group("Enemy Damage Area"):
			target.get_parent().take_damage(get_pos())
			punchhit = true
		
		if target.is_in_group("Pot Damage Area"):
			target.get_parent().take_damage()
			punchhit = true
	
	if punchhit:
		soundNode.play("punch")
	else:
		soundNode.play("miss")


func got_key():
	soundNode.play("keypickup")


func _ready():
	set_fixed_process(true)


func _fixed_process(delta):
	if state == STATE_PLAYING:
		var newAnim = "idle"
		animNode.set_speed(1.0)
		
		var moveUp = Input.is_action_pressed("MOVE_UP")
		var moveDown = Input.is_action_pressed("MOVE_DOWN")
		var moveLeft = Input.is_action_pressed("MOVE_LEFT")
		var moveRight = Input.is_action_pressed("MOVE_RIGHT")
		
		var attackInput = Input.is_action_pressed("ATTACK")
		var shootInput = Input.is_action_pressed("ATTACK2")
		
		var moving = moveUp or moveDown or moveLeft or moveRight
		
		#Movement X
		if moveLeft:
			leftFacing = true
			if movement.x > 0:
				movement.x -= dec
			elif movement.x > -top:
				movement.x -= acc
		elif moveRight:
			leftFacing = false
			if movement.x < 0:
				movement.x += dec
			elif movement.x < top:
				movement.x += acc
		else:
			movement.x -= min(abs(movement.x), frc) * sign(movement.x)
		
		#Movement Y
		if moveUp:
			upFacing = true
			if movement.y > 0:
				movement.y -= dec
			elif movement.y > -top:
				movement.y -= acc
		elif moveDown:
			upFacing = false
			if movement.y < 0:
				movement.y += dec
			elif movement.y < top:
				movement.y += acc
		else:
			movement.y -= min(abs(movement.y), frc) * sign(movement.y)
		
		#Movement normalized
		var speed = Vector2(abs(movement.x), abs(movement.y))
		var moveDir = movement.normalized()
		velocity = moveDir * speed
		
		if can_attack:
			var motion = velocity * delta
			motion.y *= scaleY
			motion = move(motion)
			
			if is_colliding():
				var normal = get_collision_normal()
				motion = normal.slide(motion)
				motion = move(motion)
		
		#Facing direction
		if leftFacing and velocity.x < 0:
			set_scale(Vector2(-1, 1))
		elif not leftFacing and velocity.x > 0:
			set_scale(Vector2(1, 1))
		
		#Rotation
		if moving:
			direction = moveDir
			
			newAnim = "walk"
			animNode.set_speed(1.25)
			
			var ang = atan2(direction.x, direction.y)
			if leftFacing and velocity.x < 0:
				ang = atan2(direction.y, direction.x) - deg2rad(90)
			
			get_node("GroundOffset/Arrow").set_rot(ang)
			get_node("AttackAxis").set_rot(ang)
		
		#Attacking
		if can_attack and attackInput and not attacking:
			can_attack = false
			get_node("Attack Cooldown").start()
			
			do_attack()
			
			var eff = meleeEffectScene.instance()
			get_parent().add_child(eff)
			eff.set_pos(get_node("AttackAxis/Punch").get_global_transform().get_origin())
			eff.set_effect_rot(atan2(direction.x, direction.y))
			eff.set_fast(moving)
		
		attacking = attackInput
		
		if can_attack and shootInput and not shooting:
			can_attack = false
			get_node("Attack Cooldown").start()
			
			soundNode.play("shoot")
			
			var bul = bulletScene.instance()
			get_parent().add_child(bul)
			bul.set_pos(get_pos())
			bul.fire(direction)
		
		shooting = shootInput
		
		if not can_attack:
			newAnim = "attack"
		
		#Damaged modulate
		if is_hurt:
			get_node("Player Sprite").set_modulate(Color(1,1,1, 0.5 + (0.5 * sin(OS.get_ticks_msec() / 10.0))))
		
		#Animation
		if upFacing:
			newAnim += "_up"
		
		if newAnim != anim:
			anim = newAnim
			animNode.play(anim)


func _on_Attack_Cooldown_timeout():
	can_attack = true


func _on_Damaged_Timer_timeout():
	is_hurt = false
	get_node("Player Sprite").set_modulate(Color(1,1,1,1))


