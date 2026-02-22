extends Node

class_name LLMService

enum Model {
	GEMINI_2_0_FLASH,
	GEMINI_2_5_FLASH,
	GEMINI_3_0_FLASH,
	GEMINI_FLASH_LATEST,
}

# Instead of keys, we map the models to the name of the variable in the .env file
var model_configs: Dictionary = {
	#Model.OPENAI_GPT_4O_MINI: {
		#"provider": "openai",
		#"env_var": "OPENAI_API_KEY",
		#"model_name": "gpt-4o-mini"
	#},
	#Model.CLAUDE_3_HAIKU: {
		#"provider": "anthropic",
		#"env_var": "ANTHROPIC_API_KEY",
		#"model_name": "claude-3-haiku-20240307"
	#},
	Model.GEMINI_2_0_FLASH: {
		"provider": "google",
		"env_var": "GEMINI_API_KEY",
		"model_name": "gemini-2.0-flash"
	},
	Model.GEMINI_2_5_FLASH: {
		"provider": "google",
		"env_var": "GEMINI_API_KEY",
		"model_name": "gemini-2.5-flash"
	},
	Model.GEMINI_3_0_FLASH: {
		"provider": "google",
		"env_var": "GEMINI_API_KEY",
		"model_name": "gemini-3-flash-preview"
	},
	Model.GEMINI_FLASH_LATEST: {
		"provider": "google",
		"env_var": "GEMINI_API_KEY",
		"model_name": "gemini-flash-latest"
	},
}

var _env_data: Dictionary = {}

func _ready():
	_load_env_file()

func ask(model_id: Model, prompt: String) -> String:
	var config = model_configs[model_id]
	var provider = config["provider"]
	var env_var = config["env_var"]
	var model_name = config["model_name"]
	
	var api_key = _env_data.get(env_var, "")
	if api_key == "":
		return "Error: '%s' is missing from the .env file!" % env_var
	
	print("Making AI API request to %s to say %s" % [provider, prompt])
	
	match provider:
		#"openai":
			#return await _format_openai(prompt, api_key, model_name)
		#"anthropic":
			#return await _format_claude(prompt, api_key, model_name)
		"google":
			return await _format_gemini(prompt, api_key, model_name)
		_:
			return "Error: Unknown provider."

func _load_env_file():
	if not FileAccess.file_exists("res://.env"):
		push_warning("No .env file found at res://.env")
		return
		
	var file = FileAccess.open("res://.env", FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		
		# Skip empty lines and comments
		if line == "" or line.begins_with("#"):
			continue
			
		# Split by the first '=' sign only
		var parts = line.split("=", true, 1)
		if parts.size() == 2:
			var key = parts[0].strip_edges()
			var value = parts[1].strip_edges()
			_env_data[key] = value

func _send_client_request(url: String, headers: PackedStringArray, json_body: String) -> Dictionary:
	var client = HTTPClient.new()
	
	# 1. Parse the URL into Host and Path
	var url_stripped = url.replace("https://", "").replace("http://", "")
	var slash_index = url_stripped.find("/")
	
	var host = url_stripped.substr(0, slash_index)
	var path = url_stripped.substr(slash_index)
	
	# 2. Connect to Host
	var tls = TLSOptions.client()
	var err = client.connect_to_host(host, 443, tls)
	if err != OK: return {"error": "Failed to connect to host"}

	# 3. Wait for connection (Manual Polling)
	var timeout = 15.0 # Seconds before we give up
	var time_passed = 0.0
	
	while client.get_status() in [HTTPClient.STATUS_CONNECTING, HTTPClient.STATUS_RESOLVING]:
		client.poll()
		await get_tree().process_frame # Yield to Godot's main loop
		time_passed += get_process_delta_time()
		if time_passed > timeout:
			client.close()
			return {"error": "Connection timed out"}

	if client.get_status() != HTTPClient.STATUS_CONNECTED:
		return {"error": "Failed to establish connection"}

	# 4. Send the POST Request
	err = client.request(HTTPClient.METHOD_POST, path, headers, json_body)
	if err != OK: return {"error": "Failed to send request payload"}

	# 5. Wait for the server to reply
	time_passed = 0.0
	while client.get_status() == HTTPClient.STATUS_REQUESTING:
		client.poll()
		await get_tree().process_frame
		time_passed += get_process_delta_time()
		if time_passed > timeout:
			client.close()
			return {"error": "Server request timed out"}

	# 6. Read the Body Chunks
	var response_bytes = PackedByteArray()
	while client.get_status() == HTTPClient.STATUS_BODY:
		client.poll()
		var chunk = client.read_response_body_chunk()
		if chunk.size() > 0:
			response_bytes.append_array(chunk)
		await get_tree().process_frame

	var response_code = client.get_response_code()
	client.close() # Always close the client!

	# 7. Parse Response
	var body_string = response_bytes.get_string_from_utf8()
	if response_code >= 400:
		return {"error": "HTTP Error %d: %s" % [response_code, body_string]}

	var json_data = JSON.parse_string(body_string)
	if json_data == null:
		return {"error": "Failed to parse JSON response"}
		
	return json_data

#func _format_openai(prompt: String, api_key: String, model: String) -> String:
	#var url = "https://api.openai.com/v1/chat/completions"
	#var headers = PackedStringArray([
		#"Content-Type: application/json",
		#"Authorization: Bearer " + api_key
	#])
	#var body = {
		#"model": model,
		#"messages": [{"role": "user", "content": prompt}]
	#}
	#var response_data = await _send_client_request(url, headers, JSON.stringify(body))
	#if response_data.has("error"): return response_data["error"]
	#return response_data.get("choices", [{}])[0].get("message", {}).get("content", "Parse error.")
#
#func _format_claude(prompt: String, api_key: String, model: String) -> String:
	#var url = "https://api.anthropic.com/v1/messages"
	#var headers = PackedStringArray([
		#"Content-Type: application/json",
		#"x-api-key: " + api_key,
		#"anthropic-version: 2023-06-01"
	#])
	#var body = {
		#"model": model,
		#"max_tokens": 1024,
		#"messages": [{"role": "user", "content": prompt}]
	#}
	#var response_data = await _send_client_request(url, headers, JSON.stringify(body))
	#if response_data.has("error"): return response_data["error"]
	#return response_data.get("content", [{}])[0].get("text", "Parse error.")

func _format_gemini(prompt: String, api_key: String, model: String) -> String:
	var url = "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s" % [model, api_key]
	var headers = PackedStringArray(["Content-Type: application/json"])
	var body = {"contents": [{"parts": [{"text": prompt}]}]}
	
	var response_data = await _send_client_request(url, headers, JSON.stringify(body))
	if response_data.has("error"): return response_data["error"]
	return response_data.get("candidates", [{}])[0].get("content", {}).get("parts", [{}])[0].get("text", "Parse error.")
