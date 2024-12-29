extends Node2D

@onready var tile_map: TileMap = $TileMap

enum TILES { DARK_GRASS, GRASS, SAND, WATER, DEEP_WATER }

const SIZE: float = 256
const RADIUS: float = 280

func _ready():
	generate()

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		generate()

func generate():
	tile_map.clear()
	var noise: FastNoiseLite = FastNoiseLite.new()
	var rng = RandomNumberGenerator.new()
	noise.seed = rng.randi()
	noise.fractal_octaves = 3
	noise.fractal_lacunarity = 3.5
	noise.frequency = 0.01
	noise.noise_type = 3
	
	for i in range(-SIZE, SIZE):
		for j in range(-SIZE, SIZE):
			var dist = Vector2(i, j).distance_to(Vector2(0, 0)) / RADIUS
			var k = noise.get_noise_2d(i, j) - dist
			
			var tile = TILES.DARK_GRASS
			
			if k < -0.5:
				tile = TILES.DEEP_WATER
			elif k > -0.5 and k <= -0.4:
				tile = TILES.WATER
			elif k > -0.4 and k < -0.3:
				tile = TILES.SAND
			elif k > -0.3 and k < 0.1:
				tile = TILES.GRASS
				
			tile_map.set_cell(0, Vector2i(i, j), 0, Vector2i(tile, 0))
