extends CanvasLayer

@onready var treinador: Sprite2D = $Treinador
@onready var fala_label: RichTextLabel = $Fala

var falas: Array[String] = []
var frames: Array[int] = []

var texto_atual := 0
var escrevendo := false
var texto_completo := ""

func _ready():
	visible = false


# =============================================================
#   INICIAR DIÁLOGO
# =============================================================
func iniciar_dialogo(tipo: int) -> void:
	await get_tree().process_frame

	# escolhe as falas conforme a fase
	match tipo:
		1:
			falas = [
				"Muito prazer, meu nome é Marcio, seu treinador.",
				"Aqui está a ficha de treino que montei para você.",
				"Os exercícios estarão marcados com uma EXCLAMAÇÃO (!).",
				"Pressione (E) para interagir e (ESC) para abrir as opções.",
				"Vamos lá para o seu primeiro treino!"
			]
			frames = [0, 1, 2, 0, 1]

		2:
			falas = [
				"Seja bem-vindo de novo!",
				"O treino de hoje é de membros inferiores.",
				"Vai com tudo!"
			]
			frames = [2, 0, 1]

		3:
			falas = [
				"Bem vindo de novo campeão!",
				"Hoje vamos trabalhar o dorsal e bíceps.",
				"Se tiver dúvida me chama."
			]
			frames = [2, 1, 0]

		4:
			falas = [
				"Opa, que bom que voltou!",
				"Pode continuar de onde parou."
			]
			frames = [3, 0]

		5:
			falas = [
				"Parabéns, você concluiu seu treino!",
				"Até semana que vem!"
			]
			frames = [2, 0]

	texto_atual = 0
	visible = true
	_mostrar_fala()
	

# =============================================================
#   MOSTRAR UMA FALA
# =============================================================
func _mostrar_fala() -> void:
	if texto_atual >= falas.size():
		_fim_dialogo()
		return

	treinador.frame = frames[texto_atual]
	fala_label.text = ""

	texto_completo = falas[texto_atual]
	escrevendo = true

	_typing_effect(texto_completo)


# =============================================================
#   EFEITO DE DIGITAÇÃO
# =============================================================
func _typing_effect(texto: String) -> void:
	await get_tree().process_frame

	for i in texto.length():
		# se jogador apertou espaço para acelerar
		if not escrevendo:
			fala_label.text = texto
			return

		fala_label.text += texto[i]
		await get_tree().create_timer(0.035).timeout

	escrevendo = false


# =============================================================
#   INPUT — acelerar e avançar
# =============================================================
func _input(event):
	if not visible:
		return
	
	if event.is_action_pressed("ui_accept"):

		# ACELERAR DIGITAÇÃO
		if escrevendo:
			escrevendo = false
			return
		
		# AVANÇAR PARA PRÓXIMO TEXTO
		texto_atual += 1
		_mostrar_fala()


# =============================================================
#   FIM DO DIÁLOGO
# =============================================================
func _fim_dialogo():
	visible = false
	
	var player = _get_player()
	if player:
		player.set_pode_mover(true)


func _get_player():
	var root = get_tree().get_current_scene()
	return root.get_node_or_null("player")
