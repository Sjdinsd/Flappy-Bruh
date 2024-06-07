extends Node2D

@onready var character = $Character

var game_is_running = true
var pipe = preload("res://tower.tscn")
const GRAV = 2.3
var timer := 1
var score := 0
@onready var towers = $Towers
@onready var score_label = $Score

func add_pipe():
	var new_pipe = pipe.instantiate()
	get_node("Towers").add_child(new_pipe)
	
	var rand_y = randi_range(-150,150)
	new_pipe.position = Vector2(get_viewport_rect().size.x, (get_viewport_rect().size.y / 2) + rand_y)


func _ready():
	character.position = Vector2(100, get_viewport_rect().size.y / 2)
	add_pipe() 
	timer = 1
	score = 0


func _process(_delta):
	var all_towers = towers.get_children()
	if Input.is_action_just_pressed("restart"):
		for child in all_towers:
			child.queue_free()
		_ready()
		game_is_running = true
	
	if game_is_running == false:
		return
	
	if Input.is_action_just_pressed("jump"):
		character.position.y -= 55
	character.position.y += 3
	
	
	timer += 1
	if timer % 5 == 0:
		score += 1
		score_label.text = "Score: " + str(score)
	
	if timer == 75:
		add_pipe()
		timer = 1
	
	for child in all_towers:
		if child.position.x < 0:
			child.queue_free()
		else:
			child.position.x -= 4

func _on_character_area_entered(_area):
	game_is_running = false
