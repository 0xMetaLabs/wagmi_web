import { Config } from "@wagmi/core"
import { createAppKit } from "@reown/appkit"
import { WagmiAdapter } from '@reown/appkit-adapter-wagmi'
import { Chain, Client, createClient, EIP1193RequestFn, http, Transport, webSocket } from "viem"
import { chainsFromIds } from "./chains"
import { JSWagmiContext } from "./context"
import { waitForFocus } from "./focus"
import { JSHttpTransport, JSTransport, JSTransportBuilder, JSWebsocketTransport } from "./transport"
import { JSWagmiCoreStorage } from "./wagmi_core"


export class JSAppKit {
    _appKitInstance: ReturnType<typeof createAppKit> | undefined
    _appKit() {
        if (this._appKitInstance === undefined) {
            throw new Error('Wagmi not initialized. Call `AppKit.init` first.')
        }
        return this._appKitInstance
    }
    init(
        projectId: string,
        chains: number[],
        storage: JSWagmiCoreStorage,
        enableAnalytics: boolean,
        enableOnRamp: boolean,
        metadata: {
            name: string
            description: string
            url: string
            icons: string[]
        },
        email: boolean,
        socials: [] | undefined,
        showWallets: boolean,
        walletFeatures: boolean,
        transportBuilder: JSTransportBuilder | undefined,
        includeWalletIds: string[] | undefined, // Warning the name is not the same with documentation... https://docs.reown.com/appkit/flutter/core/options
        featuredWalletIds: string[] | undefined,
        excludeWalletIds: string[] | undefined, // Warning the name is not the same with documentation... https://docs.reown.com/appkit/flutter/core/options

    ) {
        const chainsList = chainsFromIds(chains)
        
        const wagmiAdapter = new WagmiAdapter({
            networks: chainsList,
            projectId: projectId,
            storage: storage.create(),
            client: !transportBuilder ? undefined : this.#clientBuilder(transportBuilder),
        })

        JSWagmiContext.instance.config = wagmiAdapter.wagmiConfig

        this._appKitInstance = createAppKit({
            adapters: [wagmiAdapter],
            networks: chainsList,
            projectId: projectId,
            metadata: metadata,
            features: {
                analytics: enableAnalytics,
                onramp: enableOnRamp,
                email: email,
                socials: socials?.length === 0 ? [] : socials || [],
                emailShowWallets: showWallets,
            },
            includeWalletIds: includeWalletIds,
            featuredWalletIds: featuredWalletIds,
            excludeWalletIds: excludeWalletIds,
        })
    }

    // create a dynamic configuration with given key
    createConfig(
        projectId: string,
        configKey: string,
        chains: number[],
        storage: JSWagmiCoreStorage,
        metadata: {
            name: string
            description: string
            url: string
            icons: string[]
        },
        email: boolean,
        socials: [] | undefined,
        showWallets: boolean,
        walletFeatures: boolean,
        transportBuilder: JSTransportBuilder | undefined

    ): Config {
        const chainsList = chainsFromIds(chains)
        
        const wagmiAdapter = new WagmiAdapter({
            networks: chainsList,
            projectId: projectId,
            storage: storage.create(),
            client: !transportBuilder ? undefined : this.#clientBuilder(transportBuilder),
        })
        
        const config = wagmiAdapter.wagmiConfig
        JSWagmiContext.instance.setConfig(configKey, config)
        return config
    }



    async open(): Promise<void> {
        await waitForFocus()

        await setTimeout( // Quickfix for https://github.com/archethic-foundation/wagmi_flutter_web/issues/76
            async () => await this._appKit().open(),
            300,
        )
    }

    async close(): Promise<void> {
        await waitForFocus()
        await this._appKit().close()
    }

    subscribeState(callback: (newState: any) => void): () => void {
        return this._appKit().subscribeState(callback)
    }

    #clientBuilder(transportBuilder: JSTransportBuilder): ((parameters: { chain: Chain; }) => Client<Transport<string, Record<string, any>, EIP1193RequestFn>, Chain>) {
        return (parameters: { chain: Chain; }) => {
            const transport = transportBuilder(parameters.chain.id);
            return createClient({
                chain: parameters.chain,
                transport: this.#transportBuilder(transport)
            })
        }
    }

    #transportBuilder(jsTransport: JSTransport): Transport<string, Record<string, any>, EIP1193RequestFn> {
        switch (jsTransport.type) {
            case JSHttpTransport.type:
                return http(jsTransport.url)
            case JSWebsocketTransport.type:
                return webSocket(jsTransport.url)
            default:
                throw new Error(`Unknown Transport type ${typeof jsTransport}`)
        }
    }

}
