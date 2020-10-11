extends Node2D

var Planet = preload("res://Planet.tscn")

const PLANET_PATH = 'res://assets/planets'
const STAR_PATH = 'res://assets/stars'

var viewport_size
var planets = []
var atmospheres = ["Oxygen", "Nitrogen", "Xenon"]
var dragged_planet

var min_step = 70
var max_step = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	$ParamPlanete.hide()
	randomize()
	var p
	var direction
	var radius
	viewport_size = get_viewport_rect().size
	var planet_sprites = get_planet_sprites()
	for n in range(4):
		p = Planet.instance()
		planets.append(p)
		add_child(p)

		p.atmosphere = atmospheres[randi()%atmospheres.size()]
		var rand_index = randi() % planet_sprites.size()
		var sprite = load("%s" % planet_sprites[rand_index])
		p.set_sprite(sprite)
		p.temp_coefficient = rand_index+1

		var s = rand_range(min_step, max_step)
		radius = Vector2(s, 0)
		direction = $Star.rotation + rand_range(-PI, PI)
		p.position = $Star.position
		p.rotation = direction
		radius = radius.rotated(p.rotation)
		p.position += radius * (n+1)
		p.connect("dragsignal", self, "_on_planet_drag")
		p.connect("clicked", self, "show_param_planet")
		p.position.x = clamp(p.position.x, 0, viewport_size.x)
		p.position.y = clamp(p.position.y, 0, viewport_size.y)

func _draw():
	var radius
	for n in range(planets.size()):
		radius = $Star.position.distance_to(planets[n].position)
		draw_arc($Star.position, radius, 0, 360, 10000, Color(255, 255, 255))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (typeof(dragged_planet) > 0) and (dragged_planet.dragging):
		var mousepos = get_viewport().get_mouse_position()
		dragged_planet.position = Vector2(mousepos.x, mousepos.y)
		dragged_planet.position.x = clamp(dragged_planet.position.x, 0, viewport_size.x)
		dragged_planet.position.y = clamp(dragged_planet.position.y, 0, viewport_size.y)
	update()


func _on_planet_drag(target):
	dragged_planet = target
	show_param_planet((target))
	#entourer la planete d'un cercle

	#calculer distance au soleil
	#puis afficher temperature de cette planete
	#afficher cout de l'operation
func show_param_planet(target):
	compute_temp(target)
	$ParamPlanete.add_text("\n %s" % target.atmosphere)
	$ParamPlanete.show()

func compute_temp(planet):
	var dist = planet.distance_to_star()
	var coef = planet.temp_coefficient
	$ParamPlanete.clear()
	$ParamPlanete.add_text("%s C*" % int(-dist*coef*1.5 + 300))
	$ParamPlanete.add_text(" - ")
	$ParamPlanete.add_text("%s C*" % int(-dist*coef*1.4 + 310))

func get_planet_sprites():
	return get_file_list(PLANET_PATH)

func get_star_sprites():
	return get_file_list(STAR_PATH)

func get_file_list(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file.ends_with("png"):
				files.append("%s/%s" % [path, file])

	dir.list_dir_end()

	return files
