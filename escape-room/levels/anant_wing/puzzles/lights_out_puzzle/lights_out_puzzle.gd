extends Puzzle

@onready var timer: Timer = $Timer
@export var light_tile_scene: PackedScene
@export var admire_time: float = 3.0
@export var grid_size: int = 5
@export var offset: int = 100
@export var randomization_limit: int = 30
var tile_size: int = 64
var grid: Array = []
var is_solved: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	assert(light_tile_scene != null, "light_tile_scene is not assigned.")
	init_grid()
	randomize_grid()

func init_grid() -> void:
	var count: int = 0
	for row in range(grid_size):
		var tile_row: Array = []
		for col in range(grid_size):
			var light_tile = light_tile_scene.instantiate()
			add_child(light_tile)
			light_tile.position = Vector2(col * tile_size + offset, row * tile_size + offset)
			light_tile.row = row
			light_tile.col = col
			light_tile.tile_clicked.connect(_on_tile_clicked)
			light_tile.id = count
			count = count + 1
			tile_row.append(light_tile)
		grid.append(tile_row)

func randomize_grid() -> void:
	for i in range(randomization_limit):
		var row = randi_range(0, grid_size - 1)
		var col = randi_range(0, grid_size - 1)
		update_grid(row, col)

func _on_tile_clicked(light_tile: LightTile) -> void:
	if is_solved:
		return
	var row: int = light_tile.row
	var col: int = light_tile.col
	update_grid(row, col)
	check_win_condition()

func update_grid(row: int, col: int):
	grid[row][col].update_state()
	if row - 1 >= 0:
		grid[row - 1][col].update_state()
	if row + 1 < grid_size:
		grid[row + 1][col].update_state()
	if col - 1 >= 0:
		grid[row][col - 1].update_state()
	if col + 1 < grid_size:
		grid[row][col + 1].update_state()

func check_win_condition() -> void:
	for row in range(grid_size):
		for col in range(grid_size):
			if grid[row][col].is_on:
				return
	#print("Lights Out Puzzle Solved!")
	is_solved = true
	timer.start(admire_time)

func _on_timer_timeout() -> void:
	solve()
