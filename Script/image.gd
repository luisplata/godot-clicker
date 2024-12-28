class_name ImageCustom

extends Node

@export var image : Texture
@export var addCount : int = 1
@export var multiply : int = 1

func GetValue() -> int:
	return addCount * multiply
