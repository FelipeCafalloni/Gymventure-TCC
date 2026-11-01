extends Control

@onready var email_input := $NinePatchRect/VBoxContainer/Email
@onready var senha_input := $NinePatchRect/VBoxContainer/Senha
@onready var login_btn := $NinePatchRect/VBoxContainer/LoginBtn
@onready var voltar_btn := $NinePatchRect/VoltarBtn
@onready var status_label := $NinePatchRect/VBoxContainer/StatusLabel

func _ready():
	login_btn.pressed.connect(_on_login_pressed)
	voltar_btn.pressed.connect(_on_voltar_pressed)


# ============================================================
# 🔵 PERMITIR ENTER EM QUALQUER LineEdit
# ============================================================
func _input(event):
	if event.is_action_pressed("ui_accept"):
		var foco = get_viewport().gui_get_focus_owner()
		if foco is LineEdit:
			_on_login_pressed()
			get_viewport().set_input_as_handled()

# ============================================================
# 🔵 LOGIN (SOMENTE LOCAL)
# ============================================================
func _on_login_pressed():
	var email = email_input.text.strip_edges()
	var senha = senha_input.text.strip_edges()

	if email == "" or senha == "":
		status_label.text = "Preencha todos os campos!"
		return

	# ← Aqui estamos no modo local sempre, sem Supabase
	var user = LocalDB.buscar_usuario(email, senha)

	if user:
		# Salva dados no GameState
		GameState.user_id = user.id
		GameState.user_name = user.nome

		status_label.text = "Bem-vindo, %s!" % user.nome

		await get_tree().create_timer(1.2).timeout
		get_tree().change_scene_to_file("res://telas/menu.tscn")
	else:
		status_label.text = "Email ou senha inválidos!"


func _on_voltar_pressed():
	get_tree().change_scene_to_file("res://telas/tela_inicial.tscn")
