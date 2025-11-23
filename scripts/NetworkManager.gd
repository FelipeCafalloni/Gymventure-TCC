# NetworkManager.gd
extends Node

func _ready():
	pass

# PATCH genérico para progress (retorna true se OK)
func patch_progress(user_id: String, body: Dictionary) -> bool:
	if user_id == "":
		push_error("NetworkManager: user_id vazio")
		return false

	var url = "%s/rest/v1/progress?user_id=eq.%s" % [GameState.SUPABASE_URL, user_id]
	var headers = GameState.get_headers()
	headers.append("Prefer: return=representation")

	var req = HTTPRequest.new()
	add_child(req)
	var err = req.request(url, headers, HTTPClient.METHOD_PATCH, JSON.stringify(body))
	if err != OK:
		push_error("NetworkManager: falha ao iniciar request")
		req.queue_free()
		return false

	var res = await req.request_completed
	req.queue_free()

	if res[0] == OK:
		return true
	else:
		push_warning("NetworkManager: request retornou erro: %s" % str(res[0]))
		return false
