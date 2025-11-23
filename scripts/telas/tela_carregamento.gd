extends CanvasLayer

@onready var painel := $Painel  # se seu nó de fundo se chama diferente, troque aqui
var _pending_scene: String = ""

func _ready():
	visible = false
	if painel:
		painel.visible = false


func show_and_load(scene_path: String) -> void:
	# mostra o overlay imediatamente
	visible = true
	if painel:
		painel.visible = true

	_pending_scene = scene_path

	# chama o carregamento de forma deferred
	# Isso impede travamento, impede que a cena atual ainda esteja no meio de _process()
	call_deferred("_load_scene_safely")


func _load_scene_safely() -> void:
	# permite que o Godot redesenhe a tela e finalize o frame atual
	await get_tree().process_frame
	await get_tree().process_frame   # segundo frame melhora a estabilidade da UI

	# espera opcional — tempo para animação de loading
	await get_tree().create_timer(1.2).timeout

	# troca REAL de cena
	get_tree().change_scene_to_file(_pending_scene)

	# caso a próxima cena não use tela de carregamento, esconda aqui
	visible = false
	if painel:
		painel.visible = false
