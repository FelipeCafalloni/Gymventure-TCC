extends Node2D

@onready var dialogo = $Diálogo


func _ready():
	var player = _get_player()
	if player:
		player.set_pode_mover(false)

	# Se ainda está carregando, não exibe diálogo agora.
	# A FASE será carregada antes do diálogo iniciar.
	if TelaCarregamento.carregando:
		return

	# Seleciona qual diálogo usar
	var tipo = GameState.fase_atual
	if _minigame_ja_completado():
		tipo = 4

	# Mostra se ainda não apareceu nesta fase
	if not GameState.dialogo_fase_mostrado:
		dialogo.iniciar_dialogo(tipo)
		GameState.dialogo_fase_mostrado = true
	else:
		# Libera movimento se já foi mostrado antes
		if player:
			player.set_pode_mover(true)


func _get_player():
	return $player


func _minigame_ja_completado() -> bool:
	return GameState.minigame1_completado or GameState.minigame2_completado
