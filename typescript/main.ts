import { JSWagmiCore } from "./src/wagmi_core"
import { JSAppKit } from "./src/appkit"

export { JSWagmiCore } from "./src/wagmi_core"
export { JSAppKit } from "./src/appkit"
declare global {
  interface Window {
    appkit: JSAppKit
    wagmiCore: JSWagmiCore
  }
}

window.appkit = new JSAppKit()
window.wagmiCore = new JSWagmiCore()

document.dispatchEvent(new Event('wagmi_flutter_web_ready'))