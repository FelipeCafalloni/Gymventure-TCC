extends Control

# Conexão com botões
func _ready():
	$NinePatchRect/VBoxContainer/CadastrarBtn.pressed.connect(_on_cadastrar_pressed)
	$NinePatchRect/VoltarBtn.pressed.connect(_on_voltar_pressed)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_cadastrar_pressed()
		var foco = get_viewport().gui_get_focus_owner()
		if foco is LineEdit:
			_on_cadastrar_pressed()
			get_viewport().set_input_as_handled()


# Cria e retorna um HTTPRequest já configurado
func criar_request() -> HTTPRequest:
	var req = HTTPRequest.new()
	add_child(req)
	return req

func _on_cadastrar_pressed():
	var nome = $NinePatchRect/VBoxContainer/Nome.text.strip_edges()
	var email = $NinePatchRect/VBoxContainer/Email.text.strip_edges()
	var senha = $NinePatchRect/VBoxContainer/Senha.text.strip_edges()
	var conf = $"NinePatchRect/VBoxContainer/Confirmação_Senha".text.strip_edges()

	if nome == "" or email == "" or senha == "" or conf == "":
		$NinePatchRect/VBoxContainer/StatusLabel.text = "Preencha todos os campos!"
		return

	if senha != conf:
		$NinePatchRect/VBoxContainer/StatusLabel.text = "Senhas não coincidem!"
		return

	if GameState.modo_local:
		var id = LocalDB.criar_usuario(nome, email, senha)
		if id == "":
			$NinePatchRect/VBoxContainer/StatusLabel.text = "Email já cadastrado!"
			return
		
		GameState.user_id = id
		GameState.user_name = nome

		$NinePatchRect/VBoxContainer/StatusLabel.text = "Cadastro local realizado!"
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://telas/tela_inicial.tscn")
		return

# Voltar para a tela inicial
func _on_voltar_pressed():
	get_tree().change_scene_to_file("res://telas/tela_inicial.tscn")
