extends CharacterBody2D

@export var speed: int = 35

@onready var animations = $animacao
@onready var sprite = $textura

var last_direction := "down"
var pode_mover: bool = true


func _ready():
	# Define posição salva no banco, se existir
	if GameState.posicao_x != 0 or GameState.posicao_y != 0:
		position = Vector2(GameState.posicao_x, GameState.posicao_y)
		print("Player carregado do GameState ->", position)
	else:
		print("Player usando posição do editor ->", position)

	_carregar_skin(GameState.skin)

	# registra o player no GameState
	GameState.player_node = self



func _physics_process(delta):
	if not pode_mover:
		velocity = Vector2.ZERO
		move_and_slide()
		animations.stop()
		return

	handle_input()
	move_and_slide()
	update_animation()

	# garante ordenação correta por profundidade
	z_index = int(position.y)



func handle_input():
	var move_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = move_dir * speed



func update_animation():
	if velocity.length() == 0:
		match last_direction:
			"up": animations.play("up")
			"down": animations.play("down")
			"side": animations.play("side")
		return

	if abs(velocity.x) > abs(velocity.y):
		animations.play("lado")
		sprite.flip_h = velocity.x < 0
		last_direction = "side"
	elif velocity.y < 0:
		animations.play("cima")
		last_direction = "up"
	else:
		animations.play("baixo")
		last_direction = "down"



# ================================================================
# Travar / destravar movimento
# ================================================================
func set_pode_mover(valor: bool):
	pode_mover = valor

	if not valor:
		velocity = Vector2.ZERO
		set_physics_process(true)  # mantém física funcionando
		print("Player travado")
	else:
		set_physics_process(true)
		print("Player liberado")



# ================================================================
# SALVAR PROGRESSO NO SUPABASE
# ================================================================
func salvar_progresso():
	if not GameState.user_id:
		push_error("Usuário não logado!")
		return

	# Decide se salva posição atual ou posição “reseteada”
	if not GameState.minigame1_completado and GameState.minigame2_completado:
		GameState.posicao_x = position.x
		GameState.posicao_y = position.y
	else:
		GameState.posicao_x = 392
		GameState.posicao_y = 257

	# Evita salvar posição inválida
	if GameState.posicao_x == 0 and GameState.posicao_y == 0:
		print("⚠ Posição (0,0) bloqueada — progresso não salvo.")
		return

	var url = "%s/rest/v1/progress?on_conflict=user_id" % GameState.SUPABASE_URL

	var body = [{
		"user_id": GameState.user_id,
		"fase_atual": GameState.fase_atual,
		"posicao_x": GameState.posicao_x,
		"posicao_y": GameState.posicao_y,
		"minigame1_completado": GameState.minigame1_completado,
		"minigame2_completado": GameState.minigame2_completado,
		"skin": GameState.skin
	}]

	var headers = GameState.get_headers()
	headers.append("Prefer: return=representation")

	var req = HTTPRequest.new()
	add_child(req)

	req.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))
	var result = await req.request_completed

	if result[0] == OK:
		print("💾 Progresso salvo com sucesso!")
	else:
		push_warning("⚠ Falha ao salvar progresso no Supabase.")

	req.queue_free()



# ================================================================
# Skin do player
# ================================================================
func _carregar_skin(skin_id: int):
	match skin_id:
		1: sprite.texture = preload("res://assets/characters/demian/demian-movimentacao.png")
		2: sprite.texture = preload("res://assets/characters/tim/tim-movimentacao.png")
		3: sprite.texture = preload("res://assets/characters/gian/gian-movimentacao.png")
		4: sprite.texture = preload("res://assets/characters/isabella/isabella-movimentacao.png")
		_:
			sprite.texture = preload("res://assets/characters/gian/gian-movimentacao.png")
			print("⚠ Skin inválida, carregando padrão.")



# ================================================================
# Abrir painel de info
# ================================================================
func abrir_painel_info(nome: String, descricao: String, textura_exercicio: Texture2D, minigame_url: String):
	var painel = get_tree().get_root().get_node("CanvasLayer/PainelInfo")
	if painel:
		painel.mostrar_info(nome, descricao, textura_exercicio, minigame_url)
		set_pode_mover(false)
