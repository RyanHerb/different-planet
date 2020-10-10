extends Node2D

var dragging = false
var viewport_size

signal dragsignal(target);

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("dragsignal",self,"_toggle_drag")
	viewport_size = get_viewport_rect().size
	
func _toggle_drag(target):
	dragging = !dragging

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_KinematicBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			emit_signal("dragsignal", self)

func distance_to_star():
	return position.distance_to(Vector2(viewport_size.x/2, viewport_size.y/2))
