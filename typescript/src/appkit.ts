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

    async openActivity(): Promise<void> {
        await waitForFocus()

        setTimeout( // Quickfix for https://github.com/archethic-foundation/wagmi_flutter_web/issues/76
            async () => await this._appKit().open({ view: 'Transactions' as any }),
            300,
        )
    }

    async openBuyCrypto(): Promise<void> {
        await waitForFocus()

        setTimeout( // Quickfix for https://github.com/archethic-foundation/wagmi_flutter_web/issues/76
            async () => await this._appKit().open({ view: 'OnRampProviders' as any }),
            300,
        )
    }

    async openMeld(options: {
        countryCode?: string
        country?: string
        sourceCurrencyCode?: string
        destinationCurrencyCode?: string
        walletAddress?: string
        amount?: string
        paymentMethod?: string
        language?: string
        locale?: string
    } = {}): Promise<void> {
        await waitForFocus()
        
        // Generate Meld link - only add parameters if explicitly provided
        const meldUrl = new URL('https://meldcrypto.com')
        const activeChain = this._appKit().getActiveChainNamespace() || 'eip155'
        
        // Required parameters (always added)
        const destinationCurrencyCode = options.destinationCurrencyCode || (activeChain === 'solana' ? 'SOL' : 'USDC')
        const walletAddress = options.walletAddress || this._appKit().getAddress() || ''
        const projectId = this._appKit().getState().selectedNetworkId || ''
        
        // Always add required parameters
        meldUrl.searchParams.append('publicKey', 'WXETMuFUQmqqybHuRkSgxv:25B8LJHSfpG6LVjR2ytU5Cwh7Z4Sch2ocoU')
        meldUrl.searchParams.append('destinationCurrencyCode', destinationCurrencyCode)
        meldUrl.searchParams.append('walletAddress', walletAddress)
        meldUrl.searchParams.append('externalCustomerId', projectId)
        
        // Only add optional parameters if explicitly provided (don't force defaults)
        if (options.countryCode) {
            meldUrl.searchParams.append('countryCode', options.countryCode)
            meldUrl.searchParams.append('region', options.countryCode)
        }
        
        if (options.country) {
            meldUrl.searchParams.append('country', options.country)
        }
        
        if (options.sourceCurrencyCode) {
            meldUrl.searchParams.append('sourceCurrencyCode', options.sourceCurrencyCode)
        }
        
        if (options.amount) {
            meldUrl.searchParams.append('amount', options.amount)
            meldUrl.searchParams.append('defaultAmount', options.amount)
        }
        
        if (options.paymentMethod) {
            meldUrl.searchParams.append('paymentMethod', options.paymentMethod)
            meldUrl.searchParams.append('defaultPaymentMethod', options.paymentMethod)
        }
        
        if (options.language) {
            meldUrl.searchParams.append('language', options.language)
        }
        
        if (options.locale) {
            meldUrl.searchParams.append('locale', options.locale)
        }
        
        // Create Meld provider object with exact same structure as ONRAMP_PROVIDERS
        const meldProvider = {
            label: 'Meld.io',
            name: 'meld',
            feeRange: '1-2%',
            url: meldUrl.toString(),
            supportedChains: ['eip155', 'solana']
        }
        
        // Try to access and set the OnRamp controller properly
        try {
            // Access OnRampController from the AppKit instance or global scope
            const appKitState = this._appKit().getState();
            
            // Try multiple ways to access OnRampController
            let OnRampController = null;
            
            // Method 1: Try from appKit controllers
            if ((this._appKit() as any).controllers?.OnRampController) {
                OnRampController = (this._appKit() as any).controllers.OnRampController;
            }
            // Method 2: Try from window/global scope
            else if ((window as any).OnRampController) {
                OnRampController = (window as any).OnRampController;
            }
            // Method 3: Try from globalThis
            else if ((globalThis as any).OnRampController) {
                OnRampController = (globalThis as any).OnRampController;
            }
            // Method 4: Try importing it from the module if available
            else {
                try {
                    const modules = await import('@reown/appkit-controllers');
                    OnRampController = modules.OnRampController;
                } catch (importError) {
                    // Import failed, continue without controller access
                }
            }
            
            // Set the provider if we found the controller
            if (OnRampController && OnRampController.setSelectedProvider) {
                OnRampController.setSelectedProvider(meldProvider);
                console.log('Meld provider set successfully:', meldProvider);
            } else {
                console.warn('OnRampController not accessible, logo may not display');
            }
        } catch (error) {
            console.warn('Error setting OnRamp provider:', error);
        }
        
        // First show the modal with buy in progress 
        setTimeout(async () => {
            await this._appKit().open({ view: 'BuyInProgress' as any });
            
            // Open Meld in popup window after modal is open (same as normal flow)
            setTimeout(() => {
                const popup = window.open(
                    meldUrl.toString(), 
                    'popupWindow', 
                    'width=600,height=800,scrollbars=yes,resizable=yes'
                )
                
                // Optional: Focus the popup window
                if (popup) {
                    popup.focus()
                }
            }, 300) // Smaller delay to open popup after modal is ready
        }, 300) // Small delay to let controller state update first
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
