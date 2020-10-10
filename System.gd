extends Node2D

var Planet = preload("res://Planet.tscn")

var planets = []

var min_step = 40
var max_step = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var screen_size = get_viewport_rect().size
	var p
	var direction
	var radius
	for n in range(4):
		p = Planet.instance()
		planets.append(p)
		add_child(p)
	
		var s = rand_range(min_step, max_step)
		radius = Vector2(s, 0)
		direction = $Star.rotation + rand_range(-PI, PI)
		p.position = $Star.position
		p.rotation = direction
		radius = radius.rotated(p.rotation)
		p.position += radius * (n+1)
		p.connect("dragsignal", self, "_on_planet_drag")
		
func _draw():
	var radius
	for n in range(planets.size()):
		radius = $Star.position.distance_to(planets[n].position)
		draw_arc($Star.position, radius, 0, 360, 10000, Color(255, 255, 255))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_planet_drag():
	update()
