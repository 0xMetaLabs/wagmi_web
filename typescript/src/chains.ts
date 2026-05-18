import * as Chains from "@wagmi/core/chains";
import { defineChain } from "viem";

const customChains: Record<number, Chains.Chain> = {
    654321: defineChain({
        id: 654321,
        name: "0xDev Chain",
        nativeCurrency: { name: "DEV", symbol: "DEV", decimals: 18 },
        rpcUrls: {
            default: { http: ["https://rpc.chain.0xmetalabs.com"] },
        },
        blockExplorers: {
            default: { name: "0xDev Explorer", url: "https://explorer.chain.0xmetalabs.com" },
        },
        testnet: true,
    }),
};

export class JSChain {
    static chainFromId(chainId: number): Chains.Chain | undefined {
        for (const chain of Object.values(Chains)) {
            if ('id' in chain) {
                if (chain.id === chainId) {
                    return chain;
                }
            }
        }

        if (customChains[chainId]) {
            return customChains[chainId];
        }

        throw new Error(`Chain with id ${chainId} not found`);
    }
}

export function chainsFromIds(chainsIds: number[]): [Chains.Chain, ...Chains.Chain[]] {
    const jsChainsRaw = chainsIds
        .map((chainString) => JSChain.chainFromId(chainString))
        .filter((value) => value !== undefined)
    if (jsChainsRaw.length == 0) throw new Error('`chains` must contain at least one element')

    return [
        jsChainsRaw[0],
        ...jsChainsRaw.slice(1),
    ]
}
