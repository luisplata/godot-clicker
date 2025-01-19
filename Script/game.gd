class_name GameRules

extends Node2D
# Doc of big numbers
# https://github.com/ChronoDK/GodotBigNumberClass/tree/master

var clickCount : Big
@export var art : Sprite2D
@export var images : Array[PackedScene] = []
var indexOfImages : int = 0
var imageCurrent : ImageCustom
var numerMax: Big = Big.new(10,24)

var save_path = "user://clicks.save"

var label : Label
signal addCount(clickers:int)

func _ready() -> void:
	clickCount = load_number()
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
	save_number(clickCount)


func save_number(big_number: Big) -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	print(big_number.toString())
	if file:
		var data = {
			"big_number": big_number.toString()  # Convierte el número a una cadena
		}
		var json = JSON.new()
		var json_data = json.stringify(data)
		file.store_string(json_data)
		print("Number saved:", big_number.toString())
	else:
		print("Error opening file for saving!")


func load_number() -> Big:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var json_data = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_data)
			print(parse_result)
			if parse_result == OK:
				var data = json.data
				if data.has("big_number"):
					return Big.new(data["big_number"])  # Reconstruye el objeto Big desde la cadena
				else:
					print("Key 'big_number' not found in JSON data.")
			else:
				print("Error parsing JSON:", parse_result.error_string)
	return Big.new("1")  # Si hay un problema, inicializa con 1
