extends CharacterBody2D

# BASIC MOVEMENT
@export var gravity: float = 400.0
@export var walk_speed: float = 200.0
@export var jump_speed: float = -350.0
@export var max_jumps: int = 2

# DASH
@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.2
@export var double_tap_time: float = 0.3

# CROUCH
@export var crouch_speed: float = 100.0

var jump_count = 0

var is_dashing = false
var dash_timer = 0.0
var dash_direction = 0

var last_left_tap = 0.0
var last_right_tap = 0.0

var is_crouching = false
var is_on_ladder = false
var is_near_ladder = false

var is_on_rope = false
var is_near_rope = false

var is_punching = false
var facing_left = false

func _physics_process(delta):

	position = position.round()

	# RESTART
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()

	# PUNCH
	if Input.is_action_just_pressed("punch") and not is_punching:
		is_punching = true
		$SoundPunch.play()
		$AnimatedSprite2D.play("Punch")
		check_punch_hit()

	# ROPE
	if is_near_rope and not is_on_rope and not is_on_floor():
		if velocity.y > 0:
			is_on_rope = true

	if is_on_rope:
		velocity.y = 0

		if Input.is_action_pressed("ui_left"):
			velocity.x = -walk_speed
		elif Input.is_action_pressed("ui_right"):
			velocity.x = walk_speed
		else:
			velocity.x = 0

		if Input.is_action_just_pressed("ui_accept"):
			is_on_rope = false
			velocity.y = jump_speed
		elif Input.is_action_pressed("ui_down"):
			is_on_rope = false
			velocity.y = 100

		move_and_slide()
		update_animation()
		return

	# LADDER
	if is_near_ladder and not is_on_ladder:
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
			is_on_ladder = true

	if is_on_ladder:
		velocity = Vector2.ZERO

		if Input.is_action_pressed("ui_up"):
			velocity.y = -walk_speed
		elif Input.is_action_pressed("ui_down"):
			velocity.y = walk_speed

		move_and_slide()

		if is_on_floor() and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
			is_on_ladder = false

		update_animation()
		return

	# CROUCH
	var was_crouching = is_crouching
	is_crouching = Input.is_action_pressed("ui_down") and is_on_floor()
	if is_crouching and not was_crouching:
		$SoundCrouch.play()

	# GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0

	# JUMP
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps and not is_crouching:
		velocity.y = jump_speed
		jump_count += 1
		$SoundJump.play()
		if jump_count == 2:
			await get_tree().create_timer(0.1).timeout
			$SoundJump.play()

	# DASH
	if is_dashing:
		dash_timer -= delta
		velocity.x = dash_direction * dash_speed

		if dash_timer <= 0:
			is_dashing = false
	else:
		handle_movement()
		handle_dash_input()

	update_animation()

	var screen_width = get_viewport_rect().size.x
	position.x = clamp(position.x, 0, screen_width)

	move_and_slide()

# PUNCH HIT CHECK
func check_punch_hit():
	await get_tree().physics_frame
	await get_tree().physics_frame

	for body in get_tree().get_nodes_in_group("deer"):
		if global_position.distance_to(body.global_position) < 100:
			body.queue_free()
			$DeerGone.play()

	for body in get_tree().get_nodes_in_group("fox"):
		if global_position.distance_to(body.global_position) < 100:
			body.hurt()

# NORMAL MOVEMENT
func handle_movement():
	var current_speed = walk_speed

	if is_crouching:
		current_speed = crouch_speed

	if Input.is_action_pressed("ui_left"):
		velocity.x = -current_speed
		facing_left = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = current_speed
		facing_left = false
	else:
		velocity.x = 0

# DASH INPUT
func handle_dash_input():
	var current_time = Time.get_ticks_msec() / 1000.0

	if Input.is_action_just_pressed("ui_left"):
		if current_time - last_left_tap <= double_tap_time:
			start_dash(-1)
		last_left_tap = current_time

	if Input.is_action_just_pressed("ui_right"):
		if current_time - last_right_tap <= double_tap_time:
			start_dash(1)
		last_right_tap = current_time

func start_dash(direction):
	if is_crouching:
		return

	is_dashing = true
	dash_timer = dash_duration
	dash_direction = direction
	$SoundDash.play()

# ANIMATION
func update_animation():

	# Punch
	if is_punching:
		return

	# Flip kiri kanan
	if velocity.x != 0:
		facing_left = velocity.x < 0
		$AnimatedSprite2D.flip_h = facing_left

	# Rope
	if is_on_rope:
		play_anim("Hang")
		if not $SoundHang.playing:
			$SoundHang.play()
		return

	# Ladder
	if is_on_ladder:
		if velocity.y != 0:
			play_anim("Climb")
			if not $SoundClimb.playing:
				$SoundClimb.play()
		else:
			$SoundClimb.stop()
		return

	$SoundClimb.stop()
	$SoundHang.stop()

	# Dash
	if is_dashing:
		play_anim("Slide")
		return

	# Crouch
	if is_crouching:
		play_anim("Crouch")
		return

	# Air
	if not is_on_floor():
		if velocity.y < 0:
			play_anim("Jump")
		else:
			play_anim("Fall")
		return

	# Ground
	if abs(velocity.x) > 150:
		play_anim("Run")
		if not $SoundWalk.playing:
			$SoundWalk.play()
	elif abs(velocity.x) > 0:
		play_anim("Walk")
		if not $SoundWalk.playing:
			$SoundWalk.play()
	else:
		play_anim("Idle")
		$SoundWalk.stop()

func play_anim(name):
	if $AnimatedSprite2D.animation != name:
		$AnimatedSprite2D.play(name)

# SIGNALS
func _on_ladder_body_entered(body):
	if body == self:
		is_near_ladder = true

func _on_ladder_body_exited(body):
	if body == self:
		is_near_ladder = false
		is_on_ladder = false

func _on_rope_body_entered(body):
	if body == self:
		is_near_rope = true

func _on_rope_body_exited(body):
	if body == self:
		is_near_rope = false
		is_on_rope = false

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "Punch":
		is_punching = false
