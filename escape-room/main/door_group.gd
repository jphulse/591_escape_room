extends Node2D

@export var doorGroup : Array[Node2D]

var highestNumber = -1

func openDoor(index:int) -> void:
	if index < highestNumber:
		closeAllDoors()
		highestNumber = -1
	else:
		doorGroup[index].open()
		highestNumber = index

func closeAllDoors() -> void:
	for door in doorGroup:
		door.close()
