@tool
extends MeshInstance3D
@onready var noiseImage
@onready var width
@onready var height

var heightData = {}
var terrain_amplitude = 36
var vertices = PackedVector3Array()
var UVs = PackedVector2Array()
var normals = PackedVector3Array()

var st = ImmediateMesh.new()

@onready var themesh = Mesh.new()
@onready var meshres = 1
@onready var meshcontainer = self

func _ready():
	create_mesh()
	
func create_mesh():
	noiseImage = load("res://WorldTerrain.exr")
	st.clear_surfaces()
	width = noiseImage.get_width()
	height = noiseImage.get_height()
	
	var heightmap = noiseImage
	
	for x in range(width+meshres):
		if x % meshres ==0:
			for y in range(height+meshres):
				if y % meshres == 0:
					heightData[Vector2(x,y)] = heightmap.get_pixel(x,y).r * terrain_amplitude
	
	for x in range(width-meshres):
		if x% meshres == 0:
			for y in range (height-meshres):
				if y % meshres == 0:
					createQuad(x,y)
					
	st.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for v in vertices.size():
		st.surface_add_vertex(vertices[v])
		st.surface_set_uv(UVs[v])
		st.surface_set_normal(normals[v])
		
func createQuad(x,y):
	print(x)
	print(y)
	var vert1
	var vert2
	var vert3
	var side1
	var side2
	var normal
	
	vert1 = Vector3(x, heightData[Vector2(x,y)], -y)
	vert2 = Vector3(x, heightData[Vector2(x,y+meshres)], -y-meshres)
	vert3 = Vector3(x+meshres, heightData[Vector2(x+meshres,y)], -y-meshres)
	vertices.push_back(vert1)
	vertices.push_back(vert2)
	vertices.push_back(vert3)
	
	UVs.push_back(Vector2(vert1.x, -vert1.z))
	UVs.push_back(Vector2(vert2.x, -vert2.z))
	UVs.push_back(Vector2(vert3.x, -vert3.z))
	
	side1 = vert2-vert1
	side2 = vert2-vert3
	normal = side1.cross(side2)
	
	for i in range(0,3):
		normals.push_back(normal)
		
	vert1 = Vector3(x, heightData[Vector2(x,y)], -y)
	vert2 = Vector3(x, heightData[Vector2(x,y+meshres)], -y-meshres)
	vert3 = Vector3(x+meshres, heightData[Vector2(x+meshres,y)], -y-meshres)
	vertices.push_back(vert1)
	vertices.push_back(vert2)
	vertices.push_back(vert3)
	
	UVs.push_back(Vector2(vert1.x, -vert1.z))
	UVs.push_back(Vector2(vert2.x, -vert2.z))
	UVs.push_back(Vector2(vert3.x, -vert3.z))
	
	side1 = vert2-vert1
	side2 = vert2-vert3
	normal = side1.cross(side2)
	
	for i in range(0,3):
		normals.push_back(normal)
