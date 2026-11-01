extends Node

@onready var dialogo := $Diálogo

# Caminhos das cenas
const FASES = {
	1: "res://telas/fase_1.tscn",
	2: "res://telas/fase_2.tscn",
	3: "res://telas/fase_3.tscn",
	4: "res://telas/créditos.tscn"
}

# Executa ao carregar a fase
func _ready():
	carregar_progresso_local()
	verificar_progresso()


# 🟢 Carrega progresso do jogador localmente
func carregar_progresso_local():
	# Se for a primeira vez que joga, inicializa
	if GameState.fase_atual <= 0:
		GameState.fase_atual = 1
		GameState.minigame1_completado = false
		GameState.minigame2_completado = false

	print("📗 Progresso carregado localmente:")
	print("Fase:", GameState.fase_atual)
	print("Mini1:", GameState.minigame1_completado)
	print("Mini2:", GameState.minigame2_completado)


# 🔄 Verifica se pode avançar de fase
func verificar_progresso():
	var fase = GameState.fase_atual
	var mini1 = GameState.minigame1_completado
	var mini2 = GameState.minigame2_completado

	print("📘 Verificando progresso:", fase, mini1, mini2)

	if mini1 and mini2:
		match fase:
			1:
				atualizar_fase_local(2)
				GameState.dialogo_fase_mostrado = false
				TelaCarregamento.show_and_load(FASES[2])

			2:
				atualizar_fase_local(3)
				GameState.dialogo_fase_mostrado = false
				TelaCarregamento.show_and_load(FASES[3])

			3:
				resetar_progresso_local()
				GameState.dialogo_fase_mostrado = false
				TelaCarregamento.show_and_load(FASES[4])
	else:
		print("⏳ Ainda há minigames pendentes nesta fase.")


# 🧠 Atualiza a fase atual (100% offline)
func atualizar_fase_local(nova_fase: int):
	GameState.fase_atual = nova_fase
	GameState.minigame1_completado = false
	GameState.minigame2_completado = false

	# posição inicial padrão
	GameState.posicao_x = 392
	GameState.posicao_y = 256

	print("✅ Fase atualizada para:", nova_fase)


# 🧹 Reseta tudo (volta ao menu)
func resetar_progresso_local():
	GameState.fase_atual = 1
	GameState.minigame1_completado = false
	GameState.minigame2_completado = false
	GameState.posicao_x = 392
	GameState.posicao_y = 256

	print("🔁 Progresso resetado localmente")
