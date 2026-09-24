sub vcl_deliver {
#FASTLY deliver
  if (client.identity == "integration-request") {
    unset resp.http.Strict-Transport-Security;

    if (std.prefixof(req.url, "/web/")) {
      call proxy_agent_download_deliver;
    }
  }
}

sub vcl_fetch {
#FASTLY fetch
  if (client.identity == "integration-request") {
    unset beresp.http.Strict-Transport-Security;

    if (std.prefixof(req.url, "/web/")) {
      call proxy_agent_download_fetch;
    }
  }
}

sub vcl_recv {
#FASTLY recv
  call handle_integration_routing;
}
