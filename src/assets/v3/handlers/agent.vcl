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
  # s-maxage only drives the edge TTL, so it is not passed on to browsers.
  # Removed on delivery, so objects cached before this version are covered too.
  unset resp.http.Cache-Control:s-maxage;

  # The edge keeps the agent for s-maxage, far longer than the browser max-age,
  # so the real age would make hits arrive already stale
  if (std.prefixof(fastly_info.state, "HIT")) {
    set resp.http.Age = "0";
    unset resp.http.Cache-Tag;
  } else {
    unset resp.http.Age;
  }
}
