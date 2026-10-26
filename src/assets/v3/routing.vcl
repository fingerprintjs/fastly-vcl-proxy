sub try_handle_v3 {
  declare local var.integration_path STRING;
  set var.integration_path = table.lookup(__config_table_name__, "INTEGRATION_PATH");

  declare local var.agent_script_path STRING;
  set var.agent_script_path = table.lookup(__config_table_name__, "AGENT_SCRIPT_DOWNLOAD_PATH");

  declare local var.get_result_path STRING;
  set var.get_result_path = table.lookup(__config_table_name__, "GET_RESULT_PATH");

  set req.url = std.replace(req.url, var.integration_path + "/", "");

  if (req.url ~ "^/?([\w|-]+)?") {
    if (std.strlen(var.get_result_path) > 0 && std.strlen(var.agent_script_path) > 0) {
      if (re.group.1 == var.agent_script_path && req.method == "GET") {
          # If the request is for the agent script, route it to the agent script
          call proxy_agent_download_recv;
      } elseif (re.group.1 == var.get_result_path && req.method == "GET") {
          # If the request is for the browser cache, route it to the browser cache
          call proxy_browser_cache_recv;
      } elseif (re.group.1 == var.get_result_path && req.method == "POST") {
          # If the request is for the identification, route it to the identification
          call proxy_identification_request;
      }
    }
  }
}
