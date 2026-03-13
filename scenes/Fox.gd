extends CharacterBody2D

@export var speed = 80
@export var gravity = 400

var direction = 1
var is_hurt = false


func _physics_process(delta):

	# jika fox sedang hurt → berhenti
	if is_hurt:
		velocity.x = 0
		move_and_slide()
		return

	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# movement
	velocity.x = direction * speed
	move_and_slide()

	# cek ujung platform
	if !$RayCast2D.is_colliding():
		turn()

	# animasi jalan
	if abs(velocity.x) > 0:
		if $AnimatedSprite2D.animation != "walk":
			$AnimatedSprite2D.play("walk")


func turn():
	direction *= -1
	$AnimatedSprite2D.flip_h = direction < 0
	$RayCast2D.position.x *= -1


func hurt():
	if is_hurt:
		return

	is_hurt = true
	$AnimatedSprite2D.play("hurt")
	$HurtSound.play() 
	
	await get_tree().create_timer(2.5).timeout
	is_hurt = false
	$AnimatedSprite2D.play("walk")
