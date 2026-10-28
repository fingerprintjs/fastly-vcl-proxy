## 2.1.2

### Patch Changes

- Use the configured dictionary name (`--config-table-name`) for the `INTEGRATION_PATH` lookup in v3 routing instead of the hardcoded `fingerprint_config` ([9d4d22a](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/9d4d22a487c73005646346bcc6672fec1481372e))

## 2.1.1

### Patch Changes

- Adjust caching logic for agent downloads:

  - Remove the client-facing `s-maxage` directive so the origin controls edge TTL.
  - Set `age` to `0` on cache hits (so browsers keep the agent for the full `max-age`) and remove it on cache misses.
  - Remove the upstream CDN's `cache-tag` on cache hits so it isn't exposed to clients. ([d7c20b7](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/d7c20b7ad00e215a7f25fa2c5d195a9196746652))

## 2.1.0

### Minor Changes

- implement `--max-connections` flag into fingerprint backends ([9379cad](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/9379cadb3009584c58c3f167ca91a2ba791df12c))

## 2.0.0

### Major Changes

- Added support for Fingerprint [JavaScript agent v4](https://docs.fingerprint.com/reference/js-agent-v4). Compatibility with JavaScript agent v3 is maintained, you can upgrade to the latest JavaScript agent at your convenience.

  When upgrading to the JavaScript agent v4, remove the scriptUrlPattern and endpoint options. Replace them with a single endpoints option pointing to the worker route of your Cloudflare proxy integration:

  ```diff
  - const fpPromise = FingerprintJS.load({
  -   apiKey: PUBLIC_API_KEY,
  -   scriptUrlPattern: "https://yourwebsite.com/INTEGRATION_PATH/AGENT_SCRIPT_DOWNLOAD_PATH?apiKey=<apiKey>&version=<version>&loaderVersion=<loaderVersion>",
  -   endpoint: "https://yourwebsite.com/INTEGRATION_PATH/GET_RESULT_PATH?region=eu",
  - });

  + const fpPromise = Fingerprint.start({
  +   apiKey: PUBLIC_API_KEY,
  +   endpoints: "https://yourwebsite.com/INTEGRATION_PATH/?region=eu",
  + });
  ```

  See [Migration guide for Fastly VCL from API v3 to API v4](http://localhost:3001/docs/fastly-vcl-v3-to-v4-migration-guide) for more details. ([41afc61](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/41afc61ea0094f53cfd2a61e1887c6fd71488481))

## 2.0.0-rc.2

### Patch Changes

- Introduce release artifact on GitHub releases ([09df897](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/09df897b7adc9ba714a33206640d9e73aa221869))

## 2.0.0-rc.1

### Patch Changes

- HSTS header now can be removed on each integration request ([71363f0](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/71363f073c19d57f84685624b8793f1d0537e3ca))

## 2.0.0-rc.0

### Major Changes

- Introduced API v4 support ([41afc61](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/41afc61ea0094f53cfd2a61e1887c6fd71488481))

## 1.0.0 (2024-07-09)

### Features

- add hsts header filter on vcl ([76e603d](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/76e603da8b6d13327de2b07262cc3b798ecb2406))
- add multi region support ([20f904b](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/20f904b0a8d886c4a507ae72d6a81430890ded4c))
- add share key and max connection arg ([27f2156](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/27f2156d06e78ed0ea4215597a2c97525b46486c))
- add status page ([895656b](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/895656b4eb4230d25ec4f529f86edd180f135935))
- add status page env checks ([46710fe](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/46710fe1f1b44d0f3423c403aacaad7ee8afe63f))
- behavior path now configurable from environment variables ([3dd69c2](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/3dd69c2e37218285b6bc4802e2e125bc38c61b19))
- move origins inside vcl ([9a9e20b](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/9a9e20bd61a295e03739f01f7b4494ff0d762ebc))
- put probe fields back and add expected_response field ([6b3f825](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/6b3f825755179d1b76d22842f15464aac59e0be2))
- remove probe fields from backends ([b1eedc8](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/b1eedc8efd96b5a79474a0e6a2c73930da889cb0))
- update routing for ingress and browser cache endpoint ([ca1a5c9](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/ca1a5c98460d3079bf53e69f594e4d0838b7db75))

### Bug Fixes

- browser cache 3rd group of regexp ([8bc5bfc](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/8bc5bfc1f086720163f4ceea5a645e3b7fbf5f94))
- browser cache endpoint regions ([515d877](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/515d8777bdac39ea5d62d78e20f071b9c5304b01))
- browser cache endpoint trailing slashes ([16c4f52](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/16c4f522957d8839fb8f9ee47ecdaf1512176340))
- browser cache endpoint url path ([9b22942](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/9b22942cea49f6805f06022a5544776c7ba30ef9))
- handle browser cache reqs without additional path ([bfdf9af](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/bfdf9aff3e4323451b8dd06f9acf1c742636ebd4))
- url for target paths ([a3973ba](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/a3973bab2f1893e04ba72ccad9c420b336017f16))

## [1.0.0-test.4](https://github.com/fingerprintjs/fastly-vcl-proxy/compare/v1.0.0-test.3...v1.0.0-test.4) (2024-07-03)

### Features

- update routing for ingress and browser cache endpoint ([ca1a5c9](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/ca1a5c98460d3079bf53e69f594e4d0838b7db75))

### Bug Fixes

- browser cache endpoint trailing slashes ([16c4f52](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/16c4f522957d8839fb8f9ee47ecdaf1512176340))
- browser cache endpoint url path ([9b22942](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/9b22942cea49f6805f06022a5544776c7ba30ef9))

## [1.0.0-test.3](https://github.com/fingerprintjs/fastly-vcl-proxy/compare/v1.0.0-test.2...v1.0.0-test.3) (2024-06-26)

### Features

- add hsts header filter on vcl ([76e603d](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/76e603da8b6d13327de2b07262cc3b798ecb2406))

## [1.0.0-test.2](https://github.com/fingerprintjs/fastly-vcl-proxy/compare/v1.0.0-test.1...v1.0.0-test.2) (2024-06-14)

### Bug Fixes

- browser cache 3rd group of regexp ([8bc5bfc](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/8bc5bfc1f086720163f4ceea5a645e3b7fbf5f94))
- browser cache endpoint regions ([515d877](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/515d8777bdac39ea5d62d78e20f071b9c5304b01))
- handle browser cache reqs without additional path ([bfdf9af](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/bfdf9aff3e4323451b8dd06f9acf1c742636ebd4))

## 1.0.0-test.1 (2024-06-14)

### Features

- add multi region support ([20f904b](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/20f904b0a8d886c4a507ae72d6a81430890ded4c))
- add share key and max connection arg ([27f2156](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/27f2156d06e78ed0ea4215597a2c97525b46486c))
- add status page ([895656b](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/895656b4eb4230d25ec4f529f86edd180f135935))
- add status page env checks ([46710fe](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/46710fe1f1b44d0f3423c403aacaad7ee8afe63f))
- behavior path now configurable from environment variables ([3dd69c2](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/3dd69c2e37218285b6bc4802e2e125bc38c61b19))
- move origins inside vcl ([9a9e20b](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/9a9e20bd61a295e03739f01f7b4494ff0d762ebc))
- put probe fields back and add expected_response field ([6b3f825](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/6b3f825755179d1b76d22842f15464aac59e0be2))
- remove probe fields from backends ([b1eedc8](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/b1eedc8efd96b5a79474a0e6a2c73930da889cb0))

### Bug Fixes

- url for target paths ([a3973ba](https://github.com/fingerprintjs/fastly-vcl-proxy/commit/a3973bab2f1893e04ba72ccad9c420b336017f16))
