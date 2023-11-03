@tool
extends CollisionShape3D
var heightmap = Image.new()
var colShape_size_ratio = 1
var height_ratio = 1.0
func _ready():
	heightmap.load("res://WorldTerrain.exr")
	heightmap.convert(Image.FORMAT_RF)
	heightmap.resize(heightmap.get_width()*colShape_size_ratio, heightmap.get_height()*colShape_size_ratio)
	var data = heightmap.get_data().to_float32_array()

	for i in range(0, data.size()):
		data[i] *= height_ratio
	shape.map_width = heightmap.get_width()
	shape.map_depth = heightmap.get_height()
	shape.map_data = data
