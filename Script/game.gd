class_name GameRules

extends Node2D

# https://github.com/ChronoDK/GodotBigNumberClass/tree/master

var clickCount : Big = Big.new(0)
@export var art : Sprite2D
@export var images : Array[PackedScene] = []
var indexOfImages : int = 0
var imageCurrent : ImageCustom
var numerMax: Big = Big.new(10,24)

var label : Label
signal addCount(clickers:int)

func _ready() -> void:
	imageCurrent  = GetNextImage()
	$Camera2D/Button.connect("Click", addClick)
	$Camera2D/Art.texture = imageCurrent.image
	$Camera2D/Label.updateCount(clickCount.toString())
	print(numerMax.toString())
	
func GetNextImage() -> ImageCustom:
	var element = images[indexOfImages]
	if element is PackedScene:
		var temp_instance = element.instantiate() as ImageCustom
		indexOfImages += 1
		if indexOfImages >= images.size():
			indexOfImages = 0
		return temp_instance
	return null
	
func addClick() -> void:
	if clickCount.isLessThan(numerMax):
		ApplyClick()

func ApplyClick() -> void:
	print(imageCurrent.name)
	clickCount.plusEquals(imageCurrent.GetValue())
	$Camera2D/Label.updateCount(clickCount.toString())
	imageCurrent  = GetNextImage()
	$Camera2D/Art.texture = imageCurrent.image
	print(imageCurrent.name)
	emit_signal("addCount", clickCount)
