---
'fastly-integration': patch
---

Adjust caching logic for agent downloads:

- Remove the client-facing `s-maxage` directive so the origin controls edge TTL.
- Set `age` to `0` on cache hits (so browsers keep the agent for the full `max-age`) and remove it on cache misses.
- Remove the upstream CDN's `cache-tag` on cache hits so it isn't exposed to clients.
