import { HardhatUserConfig } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'
import '@nomiclabs/hardhat-verify'

const privatekey: string | undefined = process.env.PRIVATE_KEY

if (!privatekey) {
    throw new Error('Private key is not defined')
}

const config: HardhatUserConfig = {
    etherscan: {
        apiKey: {
            blast_sepolia: 'blast_sepolia', // apiKey is not required, just set a placeholder
        },
        customChains: [
            {
                network: 'blast_sepolia',
                chainId: 168587773,
                urls: {
                    apiURL: 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan',
                    browserURL: 'https://testnet.blastscan.io',
                },
            },
        ],
    },
    networks: {
        blast_sepolia: {
            url: 'https://sepolia.blast.io',
            accounts: [privatekey],
        },
    },
}

export default config
