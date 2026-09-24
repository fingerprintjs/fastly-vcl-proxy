sub vcl_deliver {
#FASTLY deliver
  if (std.prefixof(client.identity, "integration-")) {
    unset resp.http.Strict-Transport-Security;
  }

  if (client.identity == "integration-agent-request") {
    call proxy_agent_download_deliver;
  }
}

sub vcl_fetch {
#FASTLY fetch
  if (std.prefixof(client.identity, "integration-")) {
    unset beresp.http.Strict-Transport-Security;
  }
}

sub vcl_recv {
#FASTLY recv
  call handle_integration_routing;
}
