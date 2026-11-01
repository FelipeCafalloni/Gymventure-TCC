extends Control

@onready var iniciar_btn := $IniciarBtn
@onready var config_btn := $ConfigBtn
@onready var sair_btn := $SairBtn
@onready var status_label := $StatusLabel
@onready var op := $Pause


func _ready():
	iniciar_btn.pressed.connect(_on_iniciar_pressed)
	config_btn.pressed.connect(_on_config_pressed)
	sair_btn.pressed.connect(_on_sair_pressed)

	# Mensagem de boas-vindas
	if GameState.user_name != "":
		status_label.text = "Olá, %s!" % GameState.user_name
	else:
		status_label.text = "Bem-vindo!"


# ==========================================================
# 🔵 BOTÃO INICIAR
# ==========================================================
func _on_iniciar_pressed():
	if GameState.user_id == "":
		status_label.text = "Faça login novamente."
		return

	status_label.text = "Carregando progresso..."
	await carregar_progresso()

	# Verifica se tem skin escolhida
	if GameState.skin == 0:
		TelaCarregamento.show_and_load("res://telas/skins.tscn")
		return

	# Carrega a fase correta
	match GameState.fase_atual:
		1: TelaCarregamento.show_and_load("res://telas/fase_1.tscn")
		2: TelaCarregamento.show_and_load("res://telas/fase_2.tscn")
		3: TelaCarregamento.show_and_load("res://telas/fase_3.tscn")
		_: TelaCarregamento.show_and_load("res://telas/fase_1.tscn")


# ==========================================================
# 🔵 CARREGAR PROGRESSO – SOMENTE LOCAL
# ==========================================================
func carregar_progresso():
	if not GameState.modo_local:
		push_error("ERRO: modo_local está desligado, mas este menu é apenas local.")
		return

	var p = LocalDB.carregar_progresso(GameState.user_id)

	if p == null:
		# Nenhum progresso → cria padrão
		criar_progresso_inicial()
		return

	# Carrega dados no GameState
	GameState.fase_atual = p.fase_atual
	GameState.posicao_x = p.posicao_x
	GameState.posicao_y = p.posicao_y
	GameState.minigame1_completado = p.minigame1_completado
	GameState.minigame2_completado = p.minigame2_completado
	GameState.skin = p.skin

	print("Menu: progresso carregado localmente ->")
	print("  Fase:", GameState.fase_atual)
	print("  Posição:", GameState.posicao_x, GameState.posicao_y)
	print("  Skin:", GameState.skin)


# ==========================================================
# 🔵 CRIAR PROGRESSO PADRÃO
# ==========================================================
func criar_progresso_inicial():
	var dados = {
		"fase_atual": 1,
		"posicao_x": 0,
		"posicao_y": 0,
		"minigame1_completado": false,
		"minigame2_completado": false,
		"skin": 0
	}

	LocalDB.salvar_progresso(GameState.user_id, dados)
	print("Menu: progresso inicial criado.")


# ==========================================================
# 🔵 BOTÃO CONFIGURAÇÕES
# ==========================================================
func _on_config_pressed():
	op.visible = true


# ==========================================================
# 🔵 BOTÃO SAIR
# ==========================================================
func _on_sair_pressed():
	GameState.user_id = ""
	GameState.user_name = ""
	GameState.fase_atual = 1
	GameState.posicao_x = 0
	GameState.posicao_y = 0
	GameState.skin = 0
	GameState.minigame1_completado = false
	GameState.minigame2_completado = false

	status_label.text = "Saindo..."
	get_tree().change_scene_to_file("res://telas/tela_inicial.tscn")
