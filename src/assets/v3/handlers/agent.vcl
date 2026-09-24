sub proxy_agent_download_recv {
  # Marks the request for vcl_deliver, the rewritten URL alone can't tell it apart from v4 requests
  set client.identity = "integration-agent-request";

  unset req.http.cookie;

  set req.backend = F_api_fpjs_io;
  if (querystring.get(req.url, "region") == "eu") {
    set req.backend = F_eu_api_fpjs_io;
  }
  if(querystring.get(req.url, "region") == "ap") {
    set req.backend = F_ap_api_fpjs_io;
  }
  declare local var.apikey STRING;
  set var.apikey = if (std.strlen(querystring.get(req.url, "apiKey")) > 0, querystring.get(req.url, "apiKey"), "");
  declare local var.version STRING;
  set var.version = if (std.strlen(querystring.get(req.url, "version")) > 0, querystring.get(req.url, "version"), "3");
  declare local var.loaderversion STRING;
  set var.loaderversion = if (std.strlen(querystring.get(req.url, "loaderVersion")) > 0, "/loader_v" + querystring.get(req.url, "loaderVersion") + ".js", "");
  set req.url = "/web/v" + var.version + "/" + var.apikey + var.loaderversion + "?" + req.url.qs;

  return(lookup);
}

sub proxy_agent_download_deliver {
  # Hits are served with Age 0 so browsers keep the agent for the full max-age
  if (std.prefixof(fastly_info.state, "HIT")) {
    set resp.http.Age = "0";
    unset resp.http.Cache-Tag;
  } else {
    unset resp.http.Age;
  }
}
