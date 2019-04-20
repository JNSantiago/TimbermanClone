extends Node

var barril = preload("res://scenes/Barril.tscn")
var barrilEsq = preload("res://scenes/BarrilEsq.tscn")
var barrilDir = preload("res://scenes/BarrilDir.tscn")

onready var timber = get_node("Timber")
onready var camera = get_node("Camera")
onready var barris = get_node("Barris")
onready var destBarris = get_node("DestBarris")

var ultini

func _ready():
	randomize()
	set_process_input(true)
	gerarIni()

func _input(event):
	event = camera.make_input_local(event)
	if event.is_action_pressed("touch"):
	#if event.type == InputEventScreenTouch and event.pressed:
		if event.position.x < 360:
			timber.esq()
		else:
			timber.dir()
		
		if !verif():
			timber.bater()
			var prim = barris.get_children()[0]
			barris.remove_child(prim)
			destBarris.add_child(prim)
			prim.destroy(timber.lado)
			
			aleaBarril(Vector2(360, 1090 - 10*172))
			descer()
			
			if verif():
				perder()
		else:
			perder()

func aleaBarril(pos):
	var num = rand_range(0, 3)
	if ultini: num = 0
	gerarBarril(int(num), pos)

func gerarBarril(tipo, pos):
	var novo
	if tipo == 0:
		novo = barril.instance()
		ultini=false
	elif tipo == 1:
		novo = barrilEsq.instance()
		novo.add_to_group("barrilEsq")
		ultini=true
	elif tipo == 2:
		novo = barrilDir.instance()
		novo.add_to_group("barrilDir")
		ultini=true
	
	novo.set_position(pos)
	barris.add_child(novo)
	
func gerarIni():
	for i in range(0, 3):
		gerarBarril(0, Vector2(360, 1090 - i*172))
	
	for i in range(3, 10):
		aleaBarril(Vector2(360, 1090 - i*172))
		
func verif():
	var lado = timber.lado
	var prim = barris.get_children()[0]
	if lado == timber.ESQ and prim.is_in_group("barrilEsq") or lado == timber.DIR and prim.is_in_group("barrilDir"):
		return true
	else:
		return false

func descer():
	for b in barris.get_children():
		b.set_position(b.get_position() + Vector2(0, 172))

func perder():
	timber.morrer()