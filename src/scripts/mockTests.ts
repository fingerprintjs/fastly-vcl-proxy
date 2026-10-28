import { execSync } from 'child_process'
import { setTimeout } from 'timers/promises'
import pkg from '../../package.json' with { type: 'json' }

function getEnv(name: string) {
  const value = process.env[name]
  if (!value) {
    throw new Error(`${name} is not set`)
  }
  return value
}

// A newly created Fastly service takes a while to propagate. Until then, requests fail
// and the mock tests time out, so wait until the integration status page is served.
async function waitForServiceReady(statusUrl: URL) {
  const timeoutMs = 5 * 60 * 1000
  const intervalMs = 5000
  const deadline = Date.now() + timeoutMs
  while (Date.now() < deadline) {
    try {
      const response = await fetch(statusUrl, { signal: AbortSignal.timeout(intervalMs) })
      const body = await response.text()
      if (response.ok && body.includes('Fingerprint Pro Fastly VCL Integration')) {
        console.info('Service is ready')
        return
      }
      console.info(`Service not ready yet, status page returned ${response.status}`)
    } catch (error) {
      console.info('Service not ready yet:', error)
    }
    await setTimeout(intervalMs)
  }
  throw new Error(`Service was not ready after ${timeoutMs / 1000}s: ${statusUrl}`)
}

async function main() {
  const apiUrl = getEnv('API_URL')
  const agentPath = `${getEnv('INTEGRATION_PATH')}/${getEnv('AGENT_PATH')}`
  const resultPath = `${getEnv('INTEGRATION_PATH')}/${getEnv('RESULT_PATH')}`
  const host = getEnv('TEST_DOMAIN')

  const agentUrl = new URL(host)
  agentUrl.pathname = agentPath

  const resultUrl = new URL(host)
  resultUrl.pathname = resultPath

  console.info('Agent download path:', agentPath)
  console.info('Get result path:', resultPath)

  const statusUrl = new URL(host)
  statusUrl.pathname = `${getEnv('INTEGRATION_PATH')}/status`
  await waitForServiceReady(statusUrl)

  console.info(`Running mock e2e tests for`, host)

  execSync(
    `npm exec -y "git+https://github.com/fingerprintjs/dx-team-mock-for-proxy-integrations-e2e-tests.git" -- --api-url="https://${apiUrl}" --exclude="ipv6" --cdn-proxy-url="${agentUrl.toString()}" --ingress-proxy-url="${resultUrl.toString()}" --traffic-name=fingerprint-pro-fastly-vcl --integration-version=${
      pkg.version
    }`,
    {
      stdio: 'inherit',
    }
  )
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
