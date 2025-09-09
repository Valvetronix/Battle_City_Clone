extends Area2D

export(float) var speed := 100.0
var direction := Vector2.ZERO  # UP, DOWN, LEFT, RIGHT
onready var sprite = $Sprite
onready var bricks: TileMap = get_node("../Level/Destructible/Bricks") # DEPENDENCIA!!!
onready var undestructible: TileMap = get_node("../Level/Undestructible/Steel") # DEPENDENCIA!!!
var tank = null

func _ready():
	# Roto el sprite según la dirección
	if direction == Vector2.UP:
		sprite.rotation_degrees = 0
	elif direction == Vector2.RIGHT:
		sprite.rotation_degrees = 90
	elif direction == Vector2.DOWN:
		sprite.rotation_degrees = 180
	elif direction == Vector2.LEFT:
		sprite.rotation_degrees = -90

func _physics_process(delta):
	position += direction * speed * delta

	if bricks:
		var cell = bricks.world_to_map(global_position)
		var tile_id = bricks.get_cellv(cell)
		if tile_id != -1: # Si no esta vacío
			bricks.take_damage(global_position, direction)
			_destroy()
			
	if undestructible:
		var cell = undestructible.world_to_map(global_position)
		var tile_id = undestructible.get_cellv(cell)
		if tile_id != -1:
			_destroy()

# Destruyo la bala y aviso al Tanque
func _destroy():
	if tank:
		tank.active_bullets -= 1
	print("Boom!")
	queue_free()

