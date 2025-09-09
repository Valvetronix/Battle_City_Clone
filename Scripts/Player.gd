extends KinematicBody2D

# Con export puedo modificar desde el inspector
export(float) var speed := 60.0
export(float) var shoot_offset = 10

var BulletScene = preload("res://Scenes/Bullet.tscn")

onready var sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D
var direction = Vector2.ZERO
var last_direction = Vector2.UP # dirección inicial
var max_bullets = 1
var active_bullets = 0

func _ready():
	sprite.animation = "move_up"

func _physics_process(delta):
	direction = Vector2.ZERO
	
	if direction != Vector2.ZERO:
		last_direction = direction # guardo la ultima dirección en caso de disparar quieto

	# Todo elif para evitar direcciones diagonales
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
	elif Input.is_action_pressed("ui_right"):
		direction.x = 1

	if Input.is_action_just_pressed("shoot"):
		shoot()

	# El tanque no debería diagonalmente, pero por las dudas
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		move_and_collide(direction * speed * delta)
	
	update_animation()

func shoot():
	if active_bullets >= max_bullets:
		return

	var bullet = BulletScene.instance()
	bullet.global_position = global_position + last_direction * shoot_offset
	bullet.direction = last_direction
	bullet.bricks = get_parent().get_node("Level/DestructibleTilemaps/Bricks")
	bullet.tank = self  # Pasamos referencia del player
	get_parent().add_child(bullet)

	active_bullets += 1
	print("Pew!")

func switch_animation(animation_name):
	sprite.animation = animation_name
	sprite.play()
	return

func update_animation():
	if direction.y != 0:
		# Movimiento vertical
		switch_animation("move_up")
		sprite.flip_v = direction.y > 0  # abajo
		sprite.flip_h = false
		last_direction = Vector2(0, direction.y)
		collision_shape.rotation_degrees = 0 if direction.y < 0 else 180

	elif direction.x != 0:
		# Movimiento horizontal
		switch_animation("move_left")
		sprite.flip_h = direction.x > 0  # derecha
		sprite.flip_v = false
		last_direction = Vector2(direction.x, 0)
		collision_shape.rotation_degrees = -90 if direction.x < 0 else 90
	else:
		sprite.stop()

	
	
	
