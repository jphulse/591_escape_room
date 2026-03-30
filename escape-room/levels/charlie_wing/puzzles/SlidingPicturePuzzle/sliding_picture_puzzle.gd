extends Puzzle

@export var source_image : Texture2D
@export var grid_size := 3
@export var tile_size := Vector2i(120, 120)
@export var shuffle_moves := 150

@onready var grid : GridContainer = $UI/Panel/MarginContainer/VBoxContainer/GridContainer

var buttons : Array[Button] = []
var board : Array[int] = []
var solved_board : Array[int] = []
var image_pieces : Dictionary = {}
var empty_value := -1

func _ready() -> void:
	super._ready()
	
	grid.columns = grid_size
	
	_create_solved_board()
	_create_buttons()
	_slice_image()
	_reset_board()
	_shuffle_board()
	_refresh_board()

func _create_solved_board() -> void:
	solved_board.clear()
	for i in range(grid_size * grid_size - 1):
		solved_board.append(i)
	solved_board.append(empty_value)

func _create_buttons() -> void:
	for child in grid.get_children():
		child.queue_free()
	buttons.clear()
	
	for i in range(grid_size * grid_size):
		var button := Button.new()
		button.custom_minimum_size = tile_size
		button.focus_mode = Control.FOCUS_NONE
		button.clip_contents = true
		button.expand_icon = true
		button.pressed.connect(_on_tile_pressed.bind(i))
		grid.add_child(button)
		buttons.append(button)

func _slice_image() -> void:
	image_pieces.clear()
	
	if source_image == null:
		push_error("SlidingPicturePuzzle: source_image is null.")
		return
	
	var image_size := source_image.get_size()
	var piece_width := int(image_size.x / grid_size)
	var piece_height := int(image_size.y / grid_size)
	
	var piece_index := 0
	for row in range(grid_size):
		for col in range(grid_size):
			if piece_index == grid_size * grid_size - 1:
				return
			
			var piece := AtlasTexture.new()
			piece.atlas = source_image
			piece.region = Rect2(
				col * piece_width,
				row * piece_height,
				piece_width,
				piece_height
			)
			image_pieces[piece_index] = piece
			piece_index += 1

func _reset_board() -> void:
	board = solved_board.duplicate()

func _shuffle_board() -> void:
	var empty_index := board.find(empty_value)
	var previous_empty_index := -1
	
	for _i in range(shuffle_moves):
		var valid_moves := _get_adjacent_indices(empty_index)
		
		if previous_empty_index in valid_moves and valid_moves.size() > 1:
			valid_moves.erase(previous_empty_index)
		
		var chosen_index := valid_moves[randi() % valid_moves.size()]
		
		board[empty_index] = board[chosen_index]
		board[chosen_index] = empty_value
		
		previous_empty_index = empty_index
		empty_index = chosen_index
	
	if board == solved_board:
		_shuffle_board()

func _refresh_board() -> void:
	for i in range(board.size()):
		var value := board[i]
		var button := buttons[i]
		
		button.icon = null
		button.text = ""
		button.disabled = false
		button.modulate = Color.WHITE
		
		if value == empty_value:
			button.disabled = true
			button.modulate = Color(0.2, 0.2, 0.2, 0.35)
		else:
			if image_pieces.has(value):
				button.icon = image_pieces[value]
			else:
				button.text = str(value + 1)

func _on_tile_pressed(index : int) -> void:
	var empty_index := board.find(empty_value)
	
	if not _is_adjacent(index, empty_index):
		return
	
	board[empty_index] = board[index]
	board[index] = empty_value
	
	_refresh_board()
	_check_if_solved()

func _check_if_solved() -> void:
	print("Current board: ", board)
	print("Solved board: ", solved_board)
	
	if board == solved_board:
		print("PUZZLE SCRIPT: solved detected")
		solve()

func _is_adjacent(a : int, b : int) -> bool:
	@warning_ignore("integer_division")
	var a_row := a / grid_size
	var a_col := a % grid_size
	@warning_ignore("integer_division")
	var b_row := b / grid_size
	var b_col := b % grid_size
	
	return abs(a_row - b_row) + abs(a_col - b_col) == 1

func _get_adjacent_indices(index : int) -> Array[int]:
	var result : Array[int] = []
	@warning_ignore("integer_division")
	var row := index / grid_size
	var col := index % grid_size
	
	if row > 0:
		result.append(index - grid_size)
	if row < grid_size - 1:
		result.append(index + grid_size)
	if col > 0:
		result.append(index - 1)
	if col < grid_size - 1:
		result.append(index + 1)
	
	return result
