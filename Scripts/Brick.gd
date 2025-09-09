extends TileMap

# IDs de los tiles
const TILE_BRICK_FULL   = 0
const TILE_BRICK_RIGHT  = 2
const TILE_BRICK_BOTTOM = 3
const TILE_BRICK_LEFT   = 4
const TILE_BRICK_TOP    = 5

# Diccionario para guardar la vida de cada celda
var brick_hp = {}  # clave = Vector2 de la celda, valor = hp

func take_damage(global_pos: Vector2, dir: Vector2):
	var cell = world_to_map(global_pos) # celda impactada
	var tile_id = get_cellv(cell)

	# Caso celda vacía
	if tile_id == -1:
		return

	# Inicializo HP si es la primera vez que recibe daño
	if not brick_hp.has(cell):
		brick_hp[cell] = 2  # ladrillo entero con 2 de vida

	# Resto vida
	brick_hp[cell] -= 1

	# Si queda media vida, cambio sprite según dirección del impacto
	if brick_hp[cell] == 1:
		match dir:
			Vector2.LEFT:  set_cellv(cell, TILE_BRICK_LEFT)
			Vector2.RIGHT: set_cellv(cell, TILE_BRICK_RIGHT)
			Vector2.UP:    set_cellv(cell, TILE_BRICK_TOP)
			Vector2.DOWN:  set_cellv(cell, TILE_BRICK_BOTTOM)

	# Si la vida llegó a 0, lo elimino
	elif brick_hp[cell] <= 0:
		set_cellv(cell, -1)
		brick_hp.erase(cell)
