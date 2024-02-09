require('@nomicfoundation/hardhat-toolbox')

require('dotenv').config()
const { INFURA_API_KEY, ETHERSCAN_API_KEY, privatekey } = process.env

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
    solidity: '0.8.19',
    networks: {
        hardhat: {
            chainId: 1337, // Local Ethereum network
        },
        Blasttestnet: {
            url: 'https://yolo-young-breeze.blast-sepolia.quiknode.pro/ca1cbc74452d8919f52ec4317d8536a153bebcf2/',
            accounts: [privatekey],
            chainId: 168587773,
        },
        // mainnet: {
        //     url: `https://mainnet.infura.io/v3/${INFURA_API_KEY}`, // Infura Mainnet URL
        //     accounts: { privatekey },
        //     chainId: 11155111,
        // },
    },
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

    paths: {
        sources: './contracts',
    },
    settings: {
        solc: {
            paths: ['node_modules/@openzeppelin/contracts'],
        },
    },
}
