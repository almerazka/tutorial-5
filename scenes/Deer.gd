extends CharacterBody2D

@export var speed = 80
@export var gravity = 400

var direction = 1
var blocked_by_player = false

func _physics_process(delta):
	
	position = position.round()
	
	if not is_on_floor():
		velocity.y += gravity * delta

	# kalau diblok player → berhenti
	if blocked_by_player:
		velocity.x = 0
	else:
		velocity.x = direction * speed

	move_and_slide()

	blocked_by_player = false

	# cek semua collision
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.is_in_group("player"):
			blocked_by_player = true

	# patrol hanya kalau tidak diblok player
	if !$RayCast2D.is_colliding() and not blocked_by_player:
		turn()

	if abs(velocity.x) > 0 and not blocked_by_player:
		if $AnimatedSprite2D.animation != "walk":
			$AnimatedSprite2D.play("walk")
	else:
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")

func turn():
	direction *= -1
	$AnimatedSprite2D.flip_h = direction < 0
	$RayCast2D.position.x *= -1
