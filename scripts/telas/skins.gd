extends Control

@onready var DemianBtn := $DemianBtn
@onready var FelipeBtn := $FelipeBtn
@onready var GianBtn := $GianBtn
@onready var IsabellaBtn := $IsabellaBtn
@onready var status_label := $StatusLabel

func _ready():
	DemianBtn.pressed.connect(_on_demian_pressed)
	FelipeBtn.pressed.connect(_on_felipe_pressed)
	GianBtn.pressed.connect(_on_gian_pressed)
	IsabellaBtn.pressed.connect(_on_isabella_pressed)

func _on_demian_pressed():
	escolher_skin(1)

func _on_felipe_pressed():
	escolher_skin(2)

func _on_gian_pressed():
	escolher_skin(3)

func _on_isabella_pressed():
	escolher_skin(4)

# ----------------------------------------
# Sistema 100% LOCAL, sem Supabase
# ----------------------------------------
func escolher_skin(num: int):
	# salva no GameState
	GameState.skin = num  

	# (opcional) atualizar texto na tela
	status_label.text = "Skin selecionada!"

	# troca de cena usando sua tela de carregamento
	TelaCarregamento.show_and_load("res://telas/fase_1.tscn")
