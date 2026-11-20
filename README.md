<p align="center">
  <a href="https://fingerprint.com">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://fingerprintjs.github.io/home/resources/logo_light.svg" />
        <source media="(prefers-color-scheme: light)" srcset="https://fingerprintjs.github.io/home/resources/logo_dark.svg" />
        <img src="https://fingerprintjs.github.io/home/resources/logo_dark.svg" alt="Fingerprint logo" width="312px" />
   </picture>
  </a>
</p>
<p align="center">
<a href="https://github.com/fingerprintjs/fastly-vcl-proxy/releases"><img src="https://img.shields.io/github/v/release/fingerprintjs/fastly-vcl-proxy" alt="Current version"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/:license-mit-blue.svg" alt="MIT license"></a>
<a href="https://discord.gg/39EpE2neBg"><img src="https://img.shields.io/discord/852099967190433792?style=logo&label=Discord&logo=Discord&logoColor=white" alt="Discord server"></a>
</p>

# Fingerprint Pro Fastly VCL Proxy Integration

[Fingerprint](https://fingerprint.com) is a device intelligence platform offering industry-leading accuracy.

Fingerprint Fastly VCL Proxy Integration is responsible for proxying identification and agent-download requests between your website and Fingerprint through your Fastly infrastructure via [VCL](https://www.fastly.com/documentation/guides/vcl/using/). The integration consists of a custom VCL file you can add to your Fastly CDN Service.

## 🚧 Requirements and expectations

- **Limited to Enterprise plan**: The Fastly VCL Proxy Integration is exclusively supported for customers on the **Enterprise** Plan. Other customers are encouraged to use [Custom subdomain setup](https://dev.fingerprint.com/docs/custom-subdomain-setup) or [Cloudflare Proxy Integration](https://dev.fingerprint.com/docs/cloudflare-integration).

- **Manual updates occasionally required**: The underlying data contract in the identification logic can change to keep up with browser updates. Using the Fastly VCL Proxy Integration might require occasional manual updates on your side. Ignoring these updates will lead to lower accuracy or service disruption.

## Getting started

This is a quick overview of the installation setup. For detailed step-by-step instructions, see the [Fastly VCL proxy integration guide in our documentation](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration).

1. Go to Fingerprint **Dashboard** > [**API Keys**](https://dashboard.fingerprint.com/api-keys) and click **Create Proxy Key** to create a proxy secret. You will use it later to authenticate your requests to Fingerprint APIs.
2. Create a Dictionary in your Fastly CDN Service named `fingerprint_config` and add the following values:

   | Key                        | Example Value        | Description                                             |
   | -------------------------- | -------------------- | ------------------------------------------------------- |
   | PROXY_SECRET               | 6XI9CLf3C9oHSB12TTaI | Fingerprint proxy secret generated in Step 1            |
   | INTEGRATION_PATH           | 02mbd3               | Random path prefix for proxy integration endpoints      |

3. Go to [Releases](https://github.com/fingerprintjs/fastly-vcl-proxy/releases) to download the latest `fingerprint-pro-fastly-vcl-integration.vcl` template file.
4. Paste the template file contents to your Fastly CDN Service's **Custom VCL**.
5. Configure the Fingerprint [JS Agent](https://dev.fingerprint.com/docs/js-agent) on your website using the paths defined in Step 2.

   ```javascript
   import * as Fingerprint from '@fingerprint/agent'

   const fp = Fingerprint.start({
     endpoints: ['https://yourwebsite.com/INTEGRATION_PATH?region=us'],
     apiKey: 'PUBLIC_API_KEY',
     region: 'us'
   });
   ```

See the [Fastly VCL proxy integration guide](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration#step-4-configure-the-fingerprint-javascript-agent-on-your-client) in our documentation for more details.

## Deploying with Terraform

You can also deploy the integration with the [Fingerprint Fastly VCL Terraform module](https://github.com/fingerprintjs/terraform-fastly-vcl-fingerprint-proxy-integration). The module creates a Fastly CDN Service with the VCL template from the releases of this repository, and creates the `fingerprint_config` dictionary. Each `terraform apply` updates the service to the newest release within the major version the module supports, currently v2.x.y.

The module uses the `fastly` provider from your configuration, so configure the provider with your Fastly API token:

```terraform
terraform {
  required_version = ">=1.5"
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 7.0.0"
    }
  }
}

provider "fastly" {
  # To use the FASTLY_API_KEY environment variable instead, leave out api_key.
  api_key = "FASTLY_API_TOKEN"
}

module "fingerprint_fastly_vcl_integration" {
  source             = "fingerprintjs/vcl-fingerprint-proxy-integration/fastly"
  version            = "~> 3.0"
  integration_domain = "metrics.yourwebsite.com"
  integration_path   = "INTEGRATION_PATH"
  main_host          = "origin.yourwebsite.com"
  proxy_secret       = "PROXY_SECRET"
}
```

For step-by-step instructions and the full list of variables, see [Deploy Fastly VCL using Terraform](https://docs.fingerprint.com/docs/deploy-fastly-vcl-using-terraform). If you use v2 of the module, see [Migrate the Fastly VCL Terraform module from v2 to v3](https://docs.fingerprint.com/docs/fastly-vcl-terraform-module-v2-to-v3-migration-guide).

## Customizing the template

If you need to customize the template configuration, you can clone this repository and build the template locally with custom parameters.

1. Clone the repository: `git clone https://github.com/fingerprintjs/fastly-vcl-proxy`
2. Run `pnpm install`
3. Build the VCL file with `pnpm build`
   - **`--config-table-name` (Optional, default: `fingerprint_config`):** Identifier name for Fastly VCL's dictionary to store Fingerprint related variables
   - **`--fpjs-domain` (Optional, default: `api.fpjs.io`):** Domain to make user identification requests
   - **`--max-connections` (Optional, default: `200`):** Maximum number of concurrent connections Fastly will open to each Fingerprint origin backend (per cache node)
4. Copy `dist/fingerprint-pro-fastly-vcl-integration.vcl` file's contents.
5. Paste contents to your Fastly CDN Service's **Custom VCL**.

If you have any questions, reach out to our [support team](https://fingerprint.com/support).

## License

This project is licensed under the [MIT license](LICENSE).
