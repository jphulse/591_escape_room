extends WaterJugPuzzle

func check_win_condition() -> void:
	var count: int = 0
	for jug in water_jug_list.get_children():
		if jug is WaterJug:
			if (jug.current_capacity == 6):
				count = count + 1
	if (count >= 1):
		print("DEBUG: Jug puzzle solved!")
		is_solved = true
		timer.start(admire_time)
