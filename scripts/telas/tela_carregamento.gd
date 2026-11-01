extends CanvasLayer

@onready var painel := $Painel

var carregando: bool = false
var _pending_scene: String = ""


func _ready():
	visible = false
	if painel:
		painel.visible = false


func show_and_load(scene_path: String) -> void:
	# Marca que está carregando (impede diálogos)
	carregando = true

	# Exibe a tela de carregamento
	visible = true
	if painel:
		painel.visible = true

	_pending_scene = scene_path

	# Troca de cena em deferred (evita conflitos)
	call_deferred("_load_scene_safely")


func _load_scene_safely() -> void:
	# Garante 2 frames limpos antes de trocar de cena
	await get_tree().process_frame
	await get_tree().process_frame

	# (Opcional) Dê tempo para animação de loading
	await get_tree().create_timer(1.0).timeout

	# Troca de cena REAL
	get_tree().change_scene_to_file(_pending_scene)

	# Após trocar, esconde o painel
	visible = false
	if painel:
		painel.visible = false

	# Marca que terminou o carregamento
	carregando = false
