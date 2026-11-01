extends Node

var caminho := "user://dados.json"
var dados := {
	"usuarios": [],
	"progresso": {}
}

func _ready():
	_carregar()

func _carregar():
	if FileAccess.file_exists(caminho):
		var f = FileAccess.open(caminho, FileAccess.READ)
		dados = JSON.parse_string(f.get_as_text())
		f.close()
	else:
		_salvar()

func _salvar():
	var f = FileAccess.open(caminho, FileAccess.WRITE)
	f.store_string(JSON.stringify(dados, "\t"))
	f.close()

# -----------------------------
#  USUÁRIOS
# -----------------------------

func criar_usuario(nome, email, senha) -> String:
	# Verifica se email já existe
	for u in dados.usuarios:
		if u.email == email:
			return ""

	# Gera ID local
	var id = "local_" + str(Time.get_unix_time_from_system())

	var novo = {
		"id": id,
		"nome": nome,
		"email": email,
		"senha": senha
	}

	dados.usuarios.append(novo)
	dados.progresso[id] = {
		"fase_atual": 1,
		"posicao_x": 0,
		"posicao_y": 0,
		"minigame1_completado": false,
		"minigame2_completado": false,
		"skin": 0
	}

	_salvar()
	return id


func buscar_usuario(email, senha):
	for u in dados.usuarios:
		if u.email == email and u.senha == senha:
			return u
	return null

# -----------------------------
#  PROGRESSO
# -----------------------------

func salvar_progresso(id, progresso_dict):
	dados.progresso[id] = progresso_dict
	_salvar()

func carregar_progresso(id):
	if id in dados.progresso:
		return dados.progresso[id]
	return null
