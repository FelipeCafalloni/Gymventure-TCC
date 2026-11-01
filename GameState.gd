extends Node

# --- Dados do usuário logado ---
var user_id: String = ""
var user_name: String = ""
var modo_local := true   # true = offline | false = Supabase

# --- Progresso atual ---
var fase_atual: int = 1
var posicao_x: float = 0
var posicao_y: float = 0
var minigame1_completado: bool = false
var minigame2_completado: bool = false
var skin: int = 0

var dialogo_fase_mostrado: bool = false

# --- Player conectado ---
var player_node: Node = null

func _ready():
	print("GameState carregado (modo_local =", modo_local, ")")

# ================================================================
# 🟢 REGISTRA PLAYER E APLICA POSIÇÃO SALVA
# ================================================================
func registrar_player(player: Node):
	player_node = player

	# Aplica posição salva
	player_node.global_position = Vector2(posicao_x, posicao_y)

	print("✔ Player registrado no GameState.")
	print("→ Posição aplicada:", posicao_x, posicao_y)

# ================================================================
# 🟢 ATUALIZA POSIÇÃO EM TEMPO REAL
# ================================================================
func atualizar_posicao():
	if player_node:
		posicao_x = player_node.global_position.x
		posicao_y = player_node.global_position.y

# ================================================================
# 🟢 SALVAR PROGRESSO (LOCAL)
# ================================================================
func salvar_progresso_global():
	atualizar_posicao()

	if modo_local:
		var dados = {
			"fase_atual": fase_atual,
			"posicao_x": posicao_x,
			"posicao_y": posicao_y,
			"minigame1_completado": minigame1_completado,
			"minigame2_completado": minigame2_completado,
			"skin": skin
		}

		LocalDB.salvar_progresso(user_id, dados)
		print("💾 Progresso salvo localmente:", dados)


# ================================================================
# 🟢 CARREGAR PROGRESSO (LOCAL)
# ================================================================
func carregar_progresso_global():
	if modo_local:
		var p = LocalDB.carregar_progresso(user_id)

		if p == null:
			print("⚠ Nenhum progresso encontrado, usando valores padrão.")
			return

		# Os dados retornam como um Dictionary, então acessamos diretamente
		fase_atual = int(p.get("fase_atual", 1))
		posicao_x = float(p.get("posicao_x", 0))
		posicao_y = float(p.get("posicao_y", 0))
		minigame1_completado = bool(p.get("minigame1_completado", false))
		minigame2_completado = bool(p.get("minigame2_completado", false))
		skin = int(p.get("skin", 0))

		print("📂 Progresso carregado localmente:")
		print("→ fase:", fase_atual,
			" mini1:", minigame1_completado,
			" mini2:", minigame2_completado,
			" skin:", skin,
			" pos:", posicao_x, posicao_y)
